clear;
clc;
Path='F:\Pycharm\ExistingPytorch\GNN_Series\Physics-Informed Neural Operator\PINO-Project1\data\Project_BSA';
FileName='150.mat';FileName=[Path,'\',FileName];
load(FileName,'input','output','MeanV','StdV','MaxV','MinV');
n=size(input,1);
dt=0.005;
DOF_flex=200;
Weights=zeros(n,DOF_flex);
DOF_excit=6;                                                               %��������������λ�ƺ��ٶ�
nSlice=40;
M=1;
K = 5e6;
C = 1e6;
K_Contact=1e4;
ConnectNum=3;
alpha_k=0.01;
alpha_c=0.01;

[~,~,~,~,~,~ ,~,Nodes,~,...
 ~,W2,Eigens2,~]=Subroutine_FlexBodyImport(1);
[TrackDOFs,Nloc]=Subroutine_InteractionSearch(0.001,Nodes);
W2_CX = W2(TrackDOFs(:,1),:);
W2_CY = W2(TrackDOFs(:,2),:);
W2_CZ = W2(TrackDOFs(:,3),:);
W2_G = [W2_CX;W2_CY;W2_CZ];
DataType='diff';
r = 0.1;                                                                  %���������

for DataIndex=1:n
    DataIndex
%% ��ȡ�ź�
    Data=[squeeze(input(DataIndex,:,:)) squeeze(output(DataIndex,:,:))];
    Data=Data(nSlice+1:end,:);
    for i=1:size(MeanV, 2)
        Data(:,i)=Data(:,i)*StdV(i)+MeanV(i);
    end
    E=Data(2:end-1,2:7);
    U_flex=Data(:,8:8+DOF_flex-1);
%     dU_flex=Data(2:end-1,20:20+DOF_flex-1);
%     ddU_flex=Data(2:end-1,35:35+DOF_flex-1);
%     dU_rigid=Data(2:end-1,59:59+DOF_rigid-1);
%     ddU_rigid=Data(2:end-1,68:68+DOF_rigid-1);
%% ����������
switch DataType
    case 'diff'
        dU_flex = (U_flex(3:end,:)-U_flex(1:end-2,:))./(2*dt);
        ddU_flex = (U_flex(3:end,:)-2.*U_flex(2:end-1,:)+U_flex(1:end-2,:))./(dt^2);
        U_flex = U_flex(2:end-1,:);
    case 'real'
        dU_flex = Data(2:end-1,8+DOF_flex:8+2*DOF_flex-1);
        ddU_flex = Data(2:end-1,8+2*DOF_flex:end);
        U_flex = U_flex(2:end-1,:);
end
%% Ϊ���б���ִ������ʩ��
    List={'dU_flex','ddU_flex','U_flex'};
    dimension = size(U_flex,1);
%     plot(dU_flex(:,1));hold on;
    for  index=1:length(List)
        var=List{index};
    eval(['Column=size(',var,',2);']);
    for column=1:Column
    eval(['Std=std(',var,'(:,column));']);
    eval([var,'(:,column)=',var,'(:,column)+r.*Std.*2.*(rand(dimension,1)-0.5);']);
    end
    end
%     plot(dU_flex(:,1));hold off;
%% ����PDE��ʧ
    % ����ȡ���ӿ���λ�ý�������λ�ƺ��ٶ�
    ConnectDis = [kron(ones(1,length(Nloc)),E(:,1))-(W2_CX * U_flex')' ...
                  kron(ones(1,length(Nloc)),E(:,2))-(W2_CY * U_flex')' ...
                  kron(ones(1,length(Nloc)),E(:,3))-(W2_CZ * U_flex')'];   % �������ӽ����������λ��
    ConnectVel = [kron(ones(1,length(Nloc)),E(:,4))-(W2_CX * dU_flex')' ...
                  kron(ones(1,length(Nloc)),E(:,5))-(W2_CY * dU_flex')' ...
                  kron(ones(1,length(Nloc)),E(:,6))-(W2_CZ * dU_flex')']; % �������ӽ�����������ٶ�     
    Fvec = zeros(size(U_flex,1),size(W2,1));
    % �����岿��ODE��ʧ
    ForceElementOutput = K.*ConnectDis + C.*ConnectVel;                    % �Ӵ���
    Gvec = ForceElementOutput * W2_G;                                      % ������˳�����Чģ̬��Ϣ�������ģ̬��
    Du = ddU_flex-Gvec+kron(ones(dimension,1),Eigens2').*U_flex+(kron(ones(dimension,1),Eigens2').*alpha_k+alpha_c).*dU_flex;
    % ��������ODE��
    for i=1:size(Du,2)
        Weights_Tem(i,1)=max(Du(50:end,i));                                % ע���г����ȵ����ã�
    end
    Weights(DataIndex,:)=Weights_Tem';
    A=1;
    clear ConnectDis ConnectVel
end
SaveFileName=['Weights_Medium_',num2str(n),'.mat'];SaveFileName=[Path,'\',SaveFileName];
save(SaveFileName,'Weights','-v7.3');