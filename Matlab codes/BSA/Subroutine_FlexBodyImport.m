function [K,M,Mappings,MMat,MatA,Eigens,outside_faces,Nodes,eps,...
          ModeNumMax,W2,Eigens2,u_bridge]=Subroutine_FlexBodyImport(SectionNumber)
%% /�ӳ���/-������ṹ�ļ�����
%% �����������ۺ�ANSYS����Ԫģ�͵���Matlab���ɵ������ļ�
%% PART0.�ļ����ݶ���
% loc = 'G:\Project1\ANSYS_Building\';                     %����ANSYS�ļ�·��
% [K,M,Mappings,MMat,MatA,Eigens,outside_faces,Nodes]=load_ANSYS_model(loc,1);%��ȡANSYS���ɵ����нṹ����
% save('Building_200.mat','K','M','Mappings','MMat','MatA','Eigens','outside_faces','Nodes');
load('Building_200.mat');

%% /���ӻ�ģ��/-ѡ��������ģ�͵Ŀ��ӻ�
Switch_Plot='Off';
if strcmp(Switch_Plot,'On')==1
plot_modal(MatA,outside_faces,Nodes,7);                                    %ѡ��-���ӻ�ģ��ģ̬����һ�ף�
end
N_DoF=3;                                                                   %ÿһ����Ԫ�ڵ�����ɶ�����
if size(Nodes,2) == 4
    Nodes(:,1) = [];                                                       % [�ڵ�����3]  1-3��Ϊx,y,z����
end
eps=5e-4;                                                                 %�ڵ������ݲ�
%% PART1.�����ṹģ̬��Ϣ����
ModeNumMax =length(Eigens);                                                           %������ṹѡȡģ̬����
W2 = MMat(:,1:ModeNumMax);                                                 %������ڵ������
Eigens2 = Eigens(1:ModeNumMax);                                            %����������Ӧ������ֵƽ��
u_bridge = zeros(2*ModeNumMax,SectionNumber);                                          %�����ṹģ̬�ռ����꣨��ʼԤ���䣩
% u_bridge=reshape(u_bridge,2*ModeNumMax,[]);
% Cheat:The first 6 modes must be considered, otherwise the structure
% cannot be able to maintain correct dynamic respose because the reamining
% modes have difficulty (especially those with low frequencies)
% compensating the interaction displacement)
end

