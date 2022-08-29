function Signal=Simulation_SeismicWave_Uniform(sample, index)
load('UD_49999.mat');
Pos=UD(index,:);
%1.���ڵ��������г�ͺ�������ģ���ƽ���˹�����
N0=500; %�ɵ�����200-600
% sample=100; %��������
a=-pi;
b=pi;
omegag=5*pi;
zetag=0.6; %��������� 
S0=0.0048933; %��ǿ�����ӣ�������Ҷȶ�Ӧ��
dt=0.001;%ʱ�䲽��0.01��0.02
T=6;%�������ʱ��10-20��
t=dt:dt:T;
wu=100;   %��ֹƵ�� 100-200
dw=wu/N0;
ww=[dw:dw:wu];
gt=12.21*(exp(-0.4*t)-exp(-0.5*t)); %���ȵ��ƺ���
Ag1=zeros(length(t),length(ww));
for i=1:sample
theda1=a+(b-a)*Pos;
end
 k=[1:1:N0];
for j=1:sample
 for k=1:N0
     Xk0(k)=sqrt(2)*cos(k*theda1(j)+pi/4);
     Yk0(k)=sqrt(2)*sin(k*theda1(j)+pi/4);
 end
   Xk(j,:)=Xk0(randperm(N0,N0));
   Yk(j,:)=Yk0(randperm(N0,N0));
end
for j=1:sample
for i=1:length(t)
    k=[1:1:N0];
    AA=sqrt(2*Specdencity(dw.*k,omegag,zetag,S0)*dw).*(cos(dw.*k*i*dt).*Xk(j,k)+sin(dw.*k*i*dt).*Yk(j,k));
	AA_M=sqrt(2*Specdencity(dw.*k,omegag,zetag,S0)*dw).*(cos(dw.*k*i*dt).*Xk(j,k)+sin(dw.*k*i*dt).*Yk(j,k))*Modulation_function(dw.*k,t(i));
 Ag2(i)=sum(AA); 
 Ag2M(i)=sum(AA_M);
end
Ag(j,:)=Ag2.*gt;
Ap(j,:)=Ag2;
AgM(j,:)=Ag2M;
end
EA=diag(cov(Ag)); %���㷽��
%% �źŴ���
Tstep=1e-4;
TimeSpline=[Tstep:Tstep:t(end)]';
for i=1:sample
    Signal(:,i)=spline(t',AgM(i,:)',TimeSpline);
end
function Sf = Specdencity(ww,omegag,zetag,S0)
Sf=S0*(omegag.^4+4*zetag.^2*omegag.^2.*ww.^2)./((omegag.^2-ww.^2).^2+4*zetag.^2*omegag.^2.*ww.^2);
end
function R=correlation_function(t,S0,omige_g,zeta_g)
%�������Ǹ��ݽ��幦�����ܶȺ����������غ���
b1=omige_g*(1+4*zeta_g^2)/zeta_g;
b2=omige_g*(1-4*zeta_g^2)/sqrt(1-zeta_g^2);
omige_d=omige_g*sqrt(1-zeta_g^2);
R=0.5*pi*S0*exp(-zeta_g*omige_g*abs(t)).*(b1*cos(omige_d*t)+b2*sin(omige_d*abs(t)));
end
function gt_w=Modulation_function(w,t)
a=0.25;
b=a+0.001;
c=0.005;
t8=(log(c*w+b)-log(a))/(c*w+(b-a));
gt_w=(exp(-a*t)-exp(-(c*w+b)*t))/(exp(-a*t8)-exp(-(c*w+b)*t8));
end
end
%% https://www.bilibili.com/video/BV11A411471Q?from=search&seid=1926256533020450712&spm_id_from=333.337.0.0