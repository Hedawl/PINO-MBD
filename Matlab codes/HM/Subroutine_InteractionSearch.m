function [TrackDOFs,Nloc] =Subroutine_InteractionSearch(epis,Nodes)
%% /��Ͻ������/-���������ϵĽ��
r=0.12;
angle = (pi/6) + [0 (2/3)*pi (4/3)*pi];
angle = [angle angle+(pi/3)];
for i=1:length(angle)
    if i<=3
        IL{i,1}=[r*cos(angle(i)) r*sin(angle(i)) 0.02];
    else
        IL{i,1}=[r*cos(angle(i)) r*sin(angle(i)) 0];
    end
end
IL=cell2mat(IL);

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

