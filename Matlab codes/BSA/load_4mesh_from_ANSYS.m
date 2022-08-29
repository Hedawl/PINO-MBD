%% ���������Ƭ-------------- �ı������� 
 
function [outside_faces] = load_4mesh_from_ANSYS(Solid)

node_order = [...
    1 2 3 4;             % ����
    1 2 6 5;             % ����
    2 3 7 6;             % �Ҳ�
    1 4 8 5;             % ���
    3 4 8 7;             % ����
    5 6 7 8];            % ����
node_order = node_order(:)';

% �ռ����е���
Faces = Solid(:,node_order);
% face1 = Faces(:,1:6:24);
Faces = [Faces(:,1:6:24);Faces(:,2:6:24);Faces(:,3:6:24);...    % ����Solid45��Ԫ������
    Faces(:,4:6:24);Faces(:,5:6:24);Faces(:,6:6:24)];  % ���е�Ԫ�ĵ��棬���棬�Ҳ࣬��࣬���棬���� [��Ԫ��*6��4]

tempFaces = Faces;
for jtr = 1:size(tempFaces,2)-1                  % 1-3ѭ�� ��ÿ������ĸ��ڵ��Ŵ�С��������
    Bo = tempFaces(:,2:end) < tempFaces(:,1:end-1);
    for itr = 1:size(tempFaces,2)-1    % 1-3ѭ��
        tempFaces(Bo(:,itr),itr:itr+1) = tempFaces(Bo(:,itr),[itr+1 itr]); 
    end
end
% tempFaces 1-4�и��ݽڵ��Ŵ�С��������
IndexNumber = 0;
cols = size(tempFaces,2);  % 4��
for itr = 1:cols
    IndexNumber = IndexNumber+tempFaces(:,itr)*(1e5)^(cols-itr);   % ����������������
end

[v,inds] = sort(IndexNumber);   % B = sort(A) ������� A ��Ԫ�ؽ�������
Faces = Faces(inds,:);
% tempFaces = tempFaces(inds,:);

% sumFaces = sum(Faces,2);

bo = diff([0;v]) == 0;
bo([bo(2:end); 0] == 1) = 1;
 
outside_faces = Faces(~bo,:);
sum(~bo)  % ����Ԫ���ܺ�

