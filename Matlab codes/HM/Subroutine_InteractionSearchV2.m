function [TrackDOFs,Nloc] =Subroutine_InteractionSearchV2(epis,Nodes)
%% /��Ͻ������/-���������ϵĽ��
r=0.12;
angle = [(1/2)*pi (7/6)*pi (11/6)*pi];
for i=1:length(angle)
        IL{i,1}=[r*cos(angle(i)) r*sin(angle(i)) 0.02];
end
IL=cell2mat(IL);
IL=[2.491e-3 118.754e-3 0.02;
    -103.623e-3, -58.993e-3, 0.02;
    102.773e-3, -58.115e-3, 0.02];
%% ������Ͻ��
for itr = 1:size(IL,1)
    tnode = IL(itr,:);
    NnodeLoc = [tnode(1)-epis tnode(2)-epis (tnode(3))-epis; ...
        tnode(1)+epis tnode(2)+epis (tnode(3))+epis];
    ConNode_num = get_nodes_by_selection(Nodes,NnodeLoc);
    Nloc(itr,1) = ConNode_num(1);
end
TrackDOFs=zeros(numel(Nloc),3);
for itr=1:numel(Nloc)
    TrackDOFs(itr,1) = (Nloc(itr)-1)*3+1;                                  %   1-��ϵ���Ŀ*2����ϵ� ������ x�������ɶ� ��ӦW2�е�����
    TrackDOFs(itr,2) = (Nloc(itr)-1)*3+2;                                  %   1-��ϵ���Ŀ*2����ϵ� ������ x�������ɶ� ��ӦW2�е�����
    TrackDOFs(itr,3) = (Nloc(itr)-1)*3+3;                                  %   1-��ϵ���Ŀ*2����ϵ� ��ֱ ��ֱ���� y�������ɶ�   ��ӦW2�е�����
end
end

