function [input,output,Flag]=VTCD_DataGeneration(ParaPack)
%% �������
ParaPack(1)=ParaPack(1)/2;
ParaPack(2)=ParaPack(2)/2;
ParaPack(3)=ParaPack(3)/2;
ParaPack(4)=ParaPack(4)/2;
ParaPack(5)=ParaPack(5)/2;
Mc=ParaPack(1);
Jc=ParaPack(2);
Mt=ParaPack(3);
Jt=ParaPack(4);
Mw=ParaPack(5);
Kpz=ParaPack(6);
Cpz=ParaPack(7);
Ksz=ParaPack(8);
Csz=ParaPack(9);
Lc=ParaPack(10);
Lt=ParaPack(11);
VX=ParaPack(12);
R=0.43;
Kkjv=ParaPack(13);
Ckjv=ParaPack(14);
%% �ֹ�ϵͳ����
mr=65;
E=2.059e11;
Iy=0.3217e-4;
%% �ۼ�ϵͳ����
Lkj=0.6;
%% ���½ṹ����
Ms=237;                                                                    %��������
Mb=682.6/2;                                                                %����������
% ���ɼ���������Ԫ����
Kbv=2.4e8;                                                                 %�����鴹��ն�(����)
Cbv=5.88e4;                                                                %�����鴹������(����)
Kw=7.8e7;                                                                  %��������иն�
Cw=8e4;                                                                    %�������������
Kfv=6.5e7;                                                                 %·���ն�
Cfv=3.1e4;                                                                 %·������
%% ���ֲ���
Vc=VX/3.6;                                                                  %���������ٶ�
X0=20;                                                                     %��������λ��
Nsub=900;                                                                  %������ڽṹ����
NM=round(Nsub/2);
Ljs=Lkj*Nsub;                                                              %������㳤��
Tz=5;                                                                      %��������ʱ��
Tstep=1e-4;                                                                %��ֵ���ֲ���
Nt=round(Tz/Tstep);                                                        %ѭ������
alpha=1/2;                                                                 %���ֲ���
beta=1/2;
g=9.81;                                                                    %�������ٶ�
Cord_fastener=0:Lkj:(Nsub-1)*Lkj;                                          %ȫ�ֹ�ۼ���������
[ ~,IrreData ]=Generator_Irregularity_Expand(1, Tstep,VX);
Step(1)=round(2*(Lc+Lt)/Vc/Tstep);
Step(2)=round(2*Lc/Vc/Tstep);
Step(3)=round(2*Lt/Vc/Tstep);
Step(4)=0;
Factor=0.001;
for i=1:4
    Irregularity(:,i)=Factor.*IrreData(Step(i)+1:Step(i)+Nt,1);
end
zeroDim=round(0.1*Nt);
fadeDim=round(0.1*Nt);
Irregularity(1:zeroDim,:)=0.*Irregularity(1:zeroDim,:);
Irregularity(zeroDim+1:zeroDim+fadeDim,:)=kron(ones(1,4),linspace(0,1,fadeDim)').*Irregularity(zeroDim+1:zeroDim+fadeDim,:);
%% ���ɶ���Ϣ����
Fnum_Car=10;
Fum_Rail=NM;
Fum_Total=Fnum_Car+Fum_Rail;
FCar_start=1;FCar_end=Fnum_Car;
FRail_start=FCar_end+1;FRail_end=FCar_end+NM;
%% ���ۼ�λ�ô��ֹ����նȾ���
KrF=zeros(length(Cord_fastener),NM);
for nf=1:length(Cord_fastener)
    for nm=1:NM
        KrF(nf,nm)=sqrt(2/(mr*Ljs))*sin(nm*pi*Cord_fastener(nf)/Ljs);      
    end
end
%% �ֹ����նȾ������
Yp=zeros(NM,length(Cord_fastener));
for nm=1:NM
    for nf=1:length(Cord_fastener)
        Yp(nm,nf)=sqrt(2/(mr*Ljs))*sin(nm*pi*Cord_fastener(nf)/Ljs);      
    end
end
Kr=zeros(NM);
for nm=1:NM
    Kr(nm,nm)=(E*Iy/mr)*(nm*pi/Ljs)^4;
end
%% ��Ӧ��ϢԤ����
X=zeros(Nt,Fum_Total);
V=zeros(Nt,Fum_Total);
A=zeros(Nt,Fum_Total);
X_Subrail=zeros(Nt,Nsub*2);
V_Subrail=zeros(Nt,Nsub*2);
A_Subrail=zeros(Nt,Nsub*2);

WheelsetForce_Store=zeros(Nt,4);
RailW_Dis_SPY=zeros(Nt,4);
for ii=1:Nt
tempo=strcat(num2str(ii/Nt*100),'%');
disp(tempo);
X0t=X0+ii*Tstep*Vc;
Xw=[X0t+2*(Lc+Lt),X0t+2*Lc,X0t+2*Lt,X0t];                                  %���㵱ǰ���ֲ����ֶ�λ��
Irrez=Irregularity(ii,:);
%% STEP1.�Է�������Ԥ�����
if ii==1
        X(ii,:)=zeros(1,Fum_Total);V(ii,:)=zeros(1,Fum_Total);A(ii,:)=zeros(1,Fum_Total);
        
%         X_Subrail(ii,:)=zeros(1,2*Nsub);V_Subrail(ii,:)=zeros(1,Fum_Total);A_Subrail(ii,:)=zeros(1,Fum_Total);
elseif ii==2
        X(ii,:)=X(ii-1,:)+V(ii-1,:)*Tstep+((1/2)+alpha)*A(ii-1,:)*Tstep^2;
        V(ii,:)=V(ii-1,:)+(1+beta)*A(ii-1,:)*Tstep;
        
        X_Subrail(ii,:)=X_Subrail(ii-1,:)+V_Subrail(ii-1,:)*Tstep+((1/2)+alpha)*A_Subrail(ii-1,:)*Tstep^2;
        V_Subrail(ii,:)=V_Subrail(ii-1,:)+(1+beta)*A_Subrail(ii-1,:)*Tstep;        
else
        X(ii,:)=X(ii-1,:)+V(ii-1,:)*Tstep+((1/2)+alpha)*A(ii-1,:)*Tstep^2-alpha*A(ii-2,:)*Tstep^2;
        V(ii,:)=V(ii-1,:)+(1+beta)*A(ii-1,:)*Tstep-beta*A(ii-2,:)*Tstep;
        
        X_Subrail(ii,:)=X_Subrail(ii-1,:)+V_Subrail(ii-1,:)*Tstep+((1/2)+alpha)*A_Subrail(ii-1,:)*Tstep^2-alpha*A_Subrail(ii-2,:)*Tstep^2;
        V_Subrail(ii,:)=V_Subrail(ii-1,:)+(1+beta)*A_Subrail(ii-1,:)*Tstep-beta*A_Subrail(ii-2,:)*Tstep;
end
X_moment=X(ii,:)';V_moment=V(ii,:)';
%% ��ȡ��ǰ��λ�Ƽ��ٶ���Ϣ
%1.����ϵͳ����
XCar=X_moment(FCar_start:FCar_end);VCar=V_moment(FCar_start:FCar_end);
%2.�ֹ첿��
XRail=X_moment(FRail_start:FRail_end);VRail=V_moment(FRail_start:FRail_end);
%3.���½ṹ
Xs=X_Subrail(ii,1:Nsub)';Vs=V_Subrail(ii,1:Nsub)';As=V_Subrail(ii,1:Nsub)';
Xb=X_Subrail(ii,Nsub+1:end)';Vb=V_Subrail(ii,Nsub+1:end)';Ab=V_Subrail(ii,Nsub+1:end)';
%% �������ڿ۽����ֶ�λ�ô���λ�ƺ��ٶ���Ϣ
KrW=zeros(NM,4);
for nm=1:NM
    for nw=1:4
        KrW(nm,nw)=sqrt(2/(mr*Ljs))*sin(nm*pi*Xw(1,nw)/Ljs);
    end
end
%% �ֶ�λ�ô��ֹ�״̬��Ϣ
RailW_Dis=KrW'*XRail;
RailW_Vel=KrW'*VRail;
RailW_Dis_SPY(ii,:)=RailW_Dis';
%% �ۼ�λ�ô��ֹ�״̬��Ϣ
RailF_Dis=KrF*XRail;
RailF_Vel=KrF*VRail;
%% �����ֹ�Ӵ����
WheelType='׶��';
if strcmp(WheelType,'׶��')==1
    G=4.57*R^(-0.149)*1e-8;
elseif strcmp(WheelType,'ĥ����')==1
    G=3.86*R^(-0.115)*1e-8;
end
%% PART2.�ֹ�������
Wheel_Dis=XCar(7:10);
for nw=1:4
    detZ(nw)=Wheel_Dis(nw)-RailW_Dis(nw)-Irrez(nw);
    if detZ(nw)<=0
        WheelForce(nw)=0;
    else
        WheelForce(nw)=((1/G)*(detZ(nw)))^(3/2);
    end
end
%% STEP5.�������ϵͳ״̬��Ϣ�����㳵��ϵͳ������
Zc=XCar(1);Spinc=XCar(2);
Zt=[XCar(3) XCar(5)];Spint=[XCar(4) XCar(6)];
Zw=[XCar(7) XCar(8) XCar(9) XCar(10)];
dZc=VCar(1);dSpinc=VCar(2);
dZt=[VCar(3) VCar(5)];dSpint=[VCar(4) VCar(6)];
dZw=[VCar(7) VCar(8) VCar(9) VCar(10)];
GeneralForceVehicle=zeros(10,1);
GeneralForceVehicle(1)=Mc*g-2*Csz*dZc-2*Ksz*Zc+Csz*dZt(1)+Ksz*Zt(1)+Csz*dZt(2)+Ksz*Zt(2);
GeneralForceVehicle(2)=-2*Csz*Lc^2*dSpinc-2*Ksz*Lc^2*Spinc-Csz*Lc*dZt(1)+Csz*Lc*dZt(2)-Ksz*Lc*Zt(1)+Ksz*Lc*Zt(2);
GeneralForceVehicle(3)=Mt*g-(2*Cpz+Csz)*dZt(1)-(2*Kpz+Ksz)*Zt(1)+Csz*dZc+Ksz*Zc...
                   +Cpz*dZw(1)+Cpz*dZw(2)+Kpz*Zw(1)+Kpz*Zw(2)-Csz*Lc*dSpinc-Ksz*Lc*Spinc;
GeneralForceVehicle(4)=-2*Cpz*Lt^2*dSpint(1)-2*Kpz*Lt^2*Spint(1)-Cpz*Lt*dZw(1)+Cpz*Lt*dZw(2)-Kpz*Lt*Zw(1)+Kpz*Lt*Zw(2);
GeneralForceVehicle(5)=Mt*g-(2*Cpz+Csz)*dZt(2)-(2*Kpz+Ksz)*Zt(2)+Csz*dZc+Ksz*Zc...
                   +Cpz*dZw(3)+Cpz*dZw(4)+Kpz*Zw(3)+Kpz*Zw(4)+Csz*Lc*dSpinc+Ksz*Lc*Spinc;
GeneralForceVehicle(6)=-2*Cpz*Lt^2*dSpint(2)-2*Kpz*Lt^2*Spint(2)-Cpz*Lt*dZw(3)+Cpz*Lt*dZw(4)-Kpz*Lt*Zw(3)+Kpz*Lt*Zw(4);
GeneralForceVehicle(7)=-Kpz*Zw(1)+Cpz*dZt(1)+Kpz*Zt(1)-Cpz*Lt*dSpint(1)-Kpz*Lt*Spint(1)-WheelForce(1)+Mw*g;
GeneralForceVehicle(8)=-Kpz*Zw(2)+Cpz*dZt(1)+Kpz*Zt(1)+Cpz*Lt*dSpint(1)+Kpz*Lt*Spint(1)-WheelForce(2)+Mw*g;
GeneralForceVehicle(9)=-Kpz*Zw(3)+Cpz*dZt(2)+Kpz*Zt(2)-Cpz*Lt*dSpint(2)-Kpz*Lt*Spint(2)-WheelForce(3)+Mw*g;
GeneralForceVehicle(10)=-Kpz*Zw(4)+Cpz*dZt(2)+Kpz*Zt(2)+Cpz*Lt*dSpint(2)+Kpz*Lt*Spint(2)-WheelForce(4)+Mw*g;
StaticForce_PreBearing=(2*Mt+Mc)*g/4;                                      %һϵ�����ȶ���
StaticForce_SecBearing=(Mc)*g/2;                                           %��ϵ�����ȶ���
GeneralForceVehicle(1)=GeneralForceVehicle(1)-2*StaticForce_SecBearing;
GeneralForceVehicle(3)=GeneralForceVehicle(3)+1*StaticForce_SecBearing-2*StaticForce_PreBearing;
GeneralForceVehicle(5)=GeneralForceVehicle(5)+1*StaticForce_SecBearing-2*StaticForce_PreBearing;
GeneralForceVehicle(7)=GeneralForceVehicle(7)+1*StaticForce_PreBearing;
GeneralForceVehicle(8)=GeneralForceVehicle(8)+1*StaticForce_PreBearing;
GeneralForceVehicle(9)=GeneralForceVehicle(9)+1*StaticForce_PreBearing;
GeneralForceVehicle(10)=GeneralForceVehicle(10)+1*StaticForce_PreBearing;

%% STEP6.�������ϵͳ��״̬��Ϣ��������ϵͳ������
%1 �ۼ�������
Fastener_Force=zeros(1,length(Cord_fastener));
Fastener_Force=Ckjv.*(RailF_Vel-Vs)+Kkjv.*(RailF_Dis-Xs);
%2 �ֹ������ؼ���
GeneralForceRail=-(Kr*XRail+Yp*Fastener_Force)+KrW*WheelForce';
%3 ����-��������
SB_Force=Cbv.*(Vs-Vb)+Kbv.*(Xs-Xb);
BG_Force=Cfv.*(Vb-0)+Cfv.*(Xb-0);
Sh_Force=Cw.*(Vb-[Vb(2:end);0])+Kw.*(Xb-[Xb(2:end);0]);
%4 ������
GeneralForceSleeper=-SB_Force+Fastener_Force;
GeneralForceBuck=-BG_Force-Sh_Force;
GneeralForceSubrail=[GeneralForceSleeper;GeneralForceBuck];
%% STEP7.�������ϵͳ����������������ɶȼ��ٶ�
Mass_Vehicle=[Mc;Jc;Mt;Jt;Mt;Jt;Mw;Mw;Mw;Mw];
Mass_Rail=ones(NM,1);
Mass_Subrail=[Ms.*ones(Nsub,1);Mb.*ones(Nsub,1)];
Acceleration_Vehicle=GeneralForceVehicle./Mass_Vehicle;
Acceleration_Rail=GeneralForceRail./Mass_Rail;
Acceleration_Subrail=GneeralForceSubrail./Mass_Subrail;
%% PART2.�������ϵͳ���ٶ�
A_SYSTEM=[Acceleration_Vehicle;Acceleration_Rail];
A(ii,:)=A_SYSTEM;
A_Subrail(ii,:)=Acceleration_Subrail;
WheelsetForce_Store(ii,:)=WheelForce;
Flag=0;
if isnan(WheelForce(1))
    Flag=1;
    break
end
%% ���ɶ�����
% A(ii,FRail_start:FRail_end)=0.*A(ii,FRail_start:FRail_end);
end
DPI=10;
Dimension=Nt/DPI;
Time=(DPI*Tstep:DPI*Tstep:DPI*Tstep*Dimension)';
input=[Time Irregularity(1:DPI:end,:) kron(ones(Dimension,1),ParaPack)];
output=[X(1:DPI:end,1:10) V(1:DPI:end,1:10) A(1:DPI:end,1:10) RailW_Dis_SPY(1:DPI:end,:)];
if Flag==1
    input=0.*input;
    output=0.*output;
end
end