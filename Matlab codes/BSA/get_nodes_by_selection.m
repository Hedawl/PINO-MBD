function OutNode_num = get_nodes_by_selection(Nodes,locs)
% locs ����������ÿһ��Ϊһ����Ԫ������  Ԥ����ϵ�����Ӽ������
% Nodes ���нڵ���ά����


if size(Nodes,2) == 4
    Nodes(:,1) = [];   % 1-3��Ϊx,y,z����
end

%% ���������������ڵ㣬�ڵ�Ŀռ�����λ�ñ���λ�������ڵ�Ŀռ�λ��֮�У����ǰ�����̾������������

bools = zeros(size(Nodes,1),1) == 0;   % [��ϵ������1]
for col = 1:3
    bools = bools & (Nodes(:,col) >= locs(1,col)) & (Nodes(:,col) <= locs(2,col));
end

OutNode_num = find(bools); % Ѱ�ҷ���

% N = size(Nodes,1);
% OutNode_num = zeros(size(locs,1),1);
% for itr = 1:size(locs,1)
%     dist = sum((Nodes-ones(N,1)*locs(itr,1:3)).^2,2);
%     [~,inds] = min(dist);
%     OutNode_num(itr) = inds;
% end

% function cal_dist(Vec)
% val = Vec(:,1).^2

%% 
% locs = [0 0 0; 1 1 1];
% get_node_by_loc(Nodes,locs)


% Nodes(433,:)
