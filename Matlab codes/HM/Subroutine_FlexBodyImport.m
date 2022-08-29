function [K1,M1,Mappings1,MMat1,MatA1,Eigens1,outside_faces1,Nodes1,eps,ModeNumMax1,W21,Eigens21,u_bridge1,...
          K2,M2,Mappings2,MMat2,MatA2,Eigens2,outside_faces2,Nodes2,ModeNumMax2,W22,Eigens22,u_bridge2]=Subroutine_FlexBodyImport(SectionNumber)
%% /�ӳ���/-������ṹ�ļ�����
%% �����������ۺ�ANSYS����Ԫģ�͵���Matlab���ɵ������ļ�
%% PART0.�ļ����ݶ���
load('IS.mat');
%% /���ӻ�ģ��/-ѡ��������ģ�͵Ŀ��ӻ�
Switch_Plot='Off';
if strcmp(Switch_Plot,'On')==1
plot_modal(MatA1,outside_faces1,Nodes1,15);                                    %ѡ��-���ӻ�ģ��ģ̬����һ�ף�
end
N_DoF=3;                                                                   %ÿһ����Ԫ�ڵ�����ɶ�����
if size(Nodes1,2) == 4
    Nodes1(:,1) = [];                 % [�ڵ�����3]  1-3��Ϊx,y,z����
    Nodes2(:,1) = [];
end
eps=5e-4;                                                                 %�ڵ������ݲ�
%% PART1.�����ṹģ̬��Ϣ����
ModeNumMax1 = 15;                                                          
ModeNumMax2 =10;
W21 = MMat1(:,1:ModeNumMax1);                                                
W22 = MMat2(:,1:ModeNumMax2);
Eigens21 = Eigens1(1:ModeNumMax1);
Eigens22 = Eigens2(1:ModeNumMax2);
u_bridge1 = zeros(2*ModeNumMax1,SectionNumber);          
u_bridge2 = zeros(2*ModeNumMax2,SectionNumber);    
end

