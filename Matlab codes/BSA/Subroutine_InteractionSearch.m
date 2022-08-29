function [TrackDOFs,Nloc] =Subroutine_InteractionSearch(epis,Nodes)
%% /��Ͻ������/-���������ϵĽ��
% xrange=[0.0-epis 0.0+epis];
% yrange=[0.01-epis 0.01+epis];
% zrange=[-0.02-epis -0.02+epis];
xrange=[-500 500];
yrange=[-500 500];
zrange=[1.56-epis 1.56+epis];
%% ������Ͻ��
NnodeLoc = [xrange(1) yrange(1) zrange(1);...
            xrange(2) yrange(2) zrange(2)];
ConNode_num = get_nodes_by_selection(Nodes,NnodeLoc);
Nloc = ConNode_num(:);

TrackDOFs=zeros(numel(Nloc),3);
for itr=1:numel(Nloc)
    TrackDOFs(itr,1) = (Nloc(itr)-1)*3+1;                                  %   1-��ϵ���Ŀ*2����ϵ� ������ x�������ɶ� ��ӦW2�е�����
    TrackDOFs(itr,2) = (Nloc(itr)-1)*3+2;                                  %   1-��ϵ���Ŀ*2����ϵ� ������ x�������ɶ� ��ӦW2�е�����
    TrackDOFs(itr,3) = (Nloc(itr)-1)*3+3;                                  %   1-��ϵ���Ŀ*2����ϵ� ��ֱ ��ֱ���� y�������ɶ�   ��ӦW2�е�����
end
end

