clear;
clc;
%% �ṹ����
E=3.55e10;
NU=0.2;
[K,M,Mappings,MMat,MatA,Eigens,outside_faces,Nodes,eps,...
 ModeNumMax,W2,Eigens2,u_bridge]=Subroutine_FlexBodyImport(1);
Elist=load('Elist.txt');                                                   %����Ԫģ�͵ĵ�Ԫ�ͽ���Ӧ��Ϣ�ļ�
%% ����λ�Ƴ�
index=473;                                                                 %ѡȡ��PINO-MBDѵ����
Path='~';
load('~\150.mat','MeanV','StdV');
Data=importdata([Path,'\','Performance',num2str(index),'.txt']);
Dis_flex=Data(:,1:200);
GTDis_flex=Data(:,201:end);
for i=1:size(Dis_flex,2)
    Dis_flex(:,i)=Dis_flex(:,i)*StdV(7+i)+MeanV(7+i);
    GTDis_flex(:,i)=GTDis_flex(:,i)*StdV(7+i)+MeanV(7+i);
end
TPick=round(2.65/5*1000);                                                                 %��������ѡȡ��ʱ��
%% ��ʵλ�Ƴ��ع�
Resource = W2 * Dis_flex(TPick,:)';                                        
GTResource = W2 * GTDis_flex(TPick,:)';
StressStore=zeros(size(Nodes,1),6);                                        %Ӧ����ϢԤ����
% h=waitbar(0,'please wait');
%% ��ȡ��Ҫ���ӵĵ�Ԫ
SPYE=load('Info_Element_Node.txt');                                        %Ĭ��ѡȡ�����еĵ�Ԫ
EList=SPYE(:,1);                                                           %����Ҫ���ӵĵ�Ԫ���
NodeList=SPYE(:,7:14);                                                     %���е�Ԫ��Ӧ�Ľڵ���
u1=zeros(24,1);
u2=u1;
StressStore=zeros(length(EList),12);                                       %���ڴ洢����Ҫ����Ӧ���ĵ�Ԫ
StressLoc=zeros(length(EList),3);                                          %�洢���е�Ԫ�����ĵ�����
%% �������е�Ԫ�ļ��α��ξ���
load('EBStoreV2.mat'); 
%EXStore�洢�����в�ͬ��״��Ԫ�ļ��ξ���
%% Ĭ�ϼ��ӵ�Ԫ����λ�õ�Ӧ��
for i=1:length(EBStoreV2)
    tempo=strcat(num2str(i/length(EBStoreV2)*100),'%');
    disp(tempo);
    for j=1:8
        NodeNum=NodeList(i,j);
        u1(3*(j-1)+1:3*j,1)=Resource((NodeNum-1)*3+1:NodeNum*3);
        u2(3*(j-1)+1:3*j,1)=GTResource((NodeNum-1)*3+1:NodeNum*3);
    end
    w1=squeeze(EBStoreV2(EList(i),:,:))*u1;
    w2=squeeze(EBStoreV2(EList(i),:,:))*u2;
    StressStore(i,:)=[(w1)' (w2)'];
end
StressStore=1E-6.*StressStore;
%% ��ȡ���нڵ������
AllNodes=importdata('FigureNode.txt');
AllNodes=reshape(AllNodes,size(AllNodes,1)*size(AllNodes,2),1);
FNodeCoord=Nodes(AllNodes,:);
for i=1:length(EList)
    % ��ȡ��Ԫ�����ĵ�λ��
    StressLoc(i,1)=mean(Nodes(NodeList(i,:),1));
    StressLoc(i,2)=mean(Nodes(NodeList(i,:),2));
    StressLoc(i,3)=mean(Nodes(NodeList(i,:),3));
end
%% ʩ��-���Խ�����ά��ֵ
X=StressLoc(:,1);
Y=StressLoc(:,2);
Z=StressLoc(:,3);
V1=StressStore(:,1);
V2=StressStore(:,2);
V3=StressStore(:,3);
Xq=Nodes(1:end,1);
Yq=Nodes(1:end,2);
Zq=Nodes(1:end,3);
Vq1 = griddata(X,Y,Z,V1,Xq,Yq,Zq);
Vq2 = griddata(X,Y,Z,V2,Xq,Yq,Zq);
Vq3 = griddata(X,Y,Z,V3,Xq,Yq,Zq);
Vq=[Vq1 Vq2 Vq3];
Vq(isnan(Vq)) = 0;
%% ʩ��-���Խ�����ά��ͼ����
scale_fcator=1e-3;
[hfig,p] = plot3_DisplaceModel2_V3(Vq(:,1),outside_faces,Nodes,scale_fcator,0,0,1);
% [hfig2,p2] = plot3_DisplaceModel2_V2(vi_GT,outside_faces,Nodes,scale_fcator,0,0,2);

