
function [K,M,Mappings,MMat,MatA,Eigens,outside_faces,Nodes] = load_ANSYS_model(loc,opt,name)

% model n.ģ��
% opt = 1 : ��ȡ���в���
% opt = 0 : ���˸նȾ�������������

% Mappings -------- 
% MMat ------------ 
% Eigens ---------- Eigens = (Freqs*2*pi).^2; ����ֵ
% outside_faces --- 
% Nodes ----------- 
  

if nargin == 1     % �������������Ŀ
    opt = 0;
end

% loc = 'E:\ANSYS\Modal4\';
% loc = 'H:\Yuzhuangzhuang\Software Data\ANSYS19.0\N03Tower_Tongling\';
input_file1 = [loc 'STIFF_MATRIX.TXT'];                % �նȾ���
input_file2 = [loc 'MASS_MATRIX.TXT'];
model_file = [loc name];
mapping_file = [loc 'STIFF_MATRIX.mapping'];
modal_file = [loc 'modefile.txt'];

%% ��ȡ�ṹ�նȾ������������ϡ��״̬���ڽ������ݴ洢��
if opt
    K = HBMatrixRead(input_file1);                                         %ͨ�����ܺ�����ȡ�ṹ�ĸնȾ���
    M = HBMatrixRead(input_file2);                                         %ͨ�����ܺ�����ȡ�ṹ����������
else
    K = [];
    M = [];
end

%% ��ȡ����Ԫ�ļ��ι�ϵ

[Nodes, Solid] = load_model_from_ANSYS(model_file);  % -------------------------->1  

Solid(:, 1:11) = [];    % ʣ�µ�ÿһ�е�1-8��Ϊ�������solid45��Ԫ��8���ڵ���

%% ��ȡ����Ԫ�ļ��ι�ϵ

% fname = model_file;
% nodes_str = '%d %d %d %e %e %e';
% solid_str = '';
% for itr = 1:19
%     solid_str = [solid_str '%d ']; %#ok<AGROW>
% end
% 
% % Geo = importdata(fname);
% fid = fopen(fname,'r');
% 
% tline = fgetl(fid);
% tline2 = [];
% while ischar(tline)
%     if strcmp(tline,'(3i8,6e20.13)')
%         num = str2double(tline2(end-6:end));
%         Nodes = zeros(num,6);
%         tline = fgetl(fid);
%         for itr = 1:num
%             vec = sscanf(tline,nodes_str);
%             Nodes(itr,1:length(vec)) = vec;
%             tline = fgetl(fid);
%         end
%         Nodes(:,[2 3]) = [];
%     elseif strcmp(tline,'(19i8)')
%         num = str2double(tline2(end-6:end));
%         Solid = zeros(num,9)*NaN;
%         tline = fgetl(fid);
%         for itr = 1:num
%             vec = sscanf(tline,solid_str);
%             if length(vec) < 19
%                 Solid(itr,1:length(vec)-10) = vec(11:end);
%                 tline = fgetl(fid);
%             else
%                 Solid(itr,:) = vec(11:19);
%                 tline = fgetl(fid);
%             end 
%         end
%         break;
%     else
%         tline2 = tline;
%         tline = fgetl(fid);
%     end
% end
% fclose(fid);
% Solid(:,1) = [];
% 
% Solid(isnan(sum(Solid,2)),:) = [];

% pMMat = pinv(MMat);
% mesh(pMMat*MMat)
%% Mapping Ѱ�ҽڵ��Ӧ��ϵ���նȾ����������ڵ��Ӧ��ϵ

% MappingCell = importdata('STIFF_MATRIX100.mapping');
MappingCell = importdata(mapping_file);
Mapping = zeros(length(MappingCell)-1,2);
for itr = 2:length(MappingCell)
    vecs = sscanf(MappingCell{itr},'%d %d');
    Mapping(itr-1,1:length(vecs)) = vecs;    % ����STIFF_MATRIX.mapping���� ����=����ά�ȣ��ڶ���Ϊ�ڵ���
end

degreeFredom_num = 3;
vec123 = [1;2;3]*ones(1,length(Mapping)/degreeFredom_num);
Mapping(:,2) = (Mapping(:,2)-1)*degreeFredom_num+vec123(:);
%��ʱMapping����ĵڶ��д洢����ÿһ�������Ŷ�Ӧ��ʵ�ʽڵ����ɶ� ��Ҫע�����mapping�ļ��в������Ѿ��������ɶȵ�Լ��������ɶ�
%Nodes�к�Mapping�ļ��ж�������ʾ�Ѿ���Լ���Ľڵ�����ɶ�
invMapping = Mapping;
[~,b] = sort(Mapping(:,2));  % B = sort(A) ������� A ��Ԫ�ؽ�������     ������������������
invMapping(:,2) = b;                       
% plot(Mapping(:,1),Mapping(:,2),'o')
% Mapping(invMapping)
% b�д洢���ǰ���ϵͳ���ɶȽ������������Ժ��Ӧ�Ľṹ�նȾ����λ������

Mapping = Mapping(:,2);  %  ��ÿ���ڵ���-1��*3+��1��2��3��
invMapping = invMapping(:,2);

Mappings = [Mapping invMapping];
% Mapping�д洢�ĵ�һ������Ϊԭʼ��mapping��Ϣ�����ڽ�����������֮ǰ��txt�е���Ϣָ�������ɶȵ����з�ʽ
% Mapping�д洢�ĵڶ�������Ϊ����֮���mapping��Ϣ�����ڽ�����������֮���txt�е���Ϣ����Ϊ���ϣ���������ɶȵ��������У����е�˳�򽫻�ΪMapping�����еĵڶ�������
% spy(K)
% spy(K(invMapping,invMapping))


%% ��ȡANSYSģ̬������

[MMat,MatA,Eigens] = load_modal_from_ANSYS(modal_file);  % -------------------------->2  


% Matp = MMat(Mapping,:);
% 
% mesh(full(Matp'*K*Matp))
% 
% figure(12)
% hold on;
% plot(diag(Matp'*K*Matp));
% plot(Eigens,'r');
% 
% plot(diag(Matp'*K*Matp)-Eigens)


%% ʹ�øնȾ����������������ģ̬����

% Lm = chol(M,'lower');            % 11124x11124 sparse double
% % mesh(full(Lm*Lm'-M))
% % invLm = inv(Lm);
% % spy(invLm)
% 
% mMat = (Lm\K)/Lm';                         % 11124x11124 sparse double
% % [Vm,D] = eigs(mMat,length(mMat));
% [Vm,D] = eig(full(mMat));   % ��ϡ�����ת��Ϊ������  [V,D] = eig(A)  DΪ����ֵ���󣨶Խ���VΪ��Ӧ��������������
% W = Lm'\Vm;
% % W2 = Lm'\Vm;
% 
% diag_D = diag(D);  % x = diag(A) ���� A �����Խ���Ԫ�ص�������   [11124,1]
% diag_D = abs(diag_D);   % ����ֵ
% [sort_diag_D,ind] = sort(diag_D);   % ԲƵ�� ����ֵ omega^2    B = sort(A) ������� A ��Ԫ�ؽ�������
% sort_diag_D(sort_diag_D < 0) = 0;
% sort_diag_D2 = sqrt(sort_diag_D)/2/pi;  % ����Ƶ�� f = omega/(2*pi)
% Wmat = W(:,ind);
% W2mat = W2(:,ind);
% Freqs = sort_diag_D2;   % ����Ƶ�� f = omega/(2*pi)
% % VV = VV(:,ind);
% % figure(11)
% % hold on;
% % plot(sort_diag_D2);
% % plot(Freqs,'r');
% 
% % mesh(full(W'*K*W-D))
% % mesh(full(Vm'*D*Vm-mMat))
% % mesh(full(Vm*mMat*Vm'-D))
% % mesh(full(D))
% % mesh(full(W'*K*W))
% % mesh(full(W'*M*W))
% % 
% % mesh(full(Wmat'*K*Wmat))
% % 
% % plot(W(:,1))
% % 
% % plot(diag(D)-diag(W'*K*W))
% % plot(diag(D))
% % 
% % plot(sum(W.^2))
% % plot(sum(Vm.^2))


%% ����mapping���ݣ���ģ̬������նȾ����Ӧ

% Modal_result = Wmat(invMapping,:);
% 
% W = MMat(:,:); % ----------- ��նȾ����Ӧ����������������
% invW = pinv(W);

%% ����ģ̬����

% ModalSum = 100;
% mode_num = 3;
% 
% Modes = 1:ModalSum;

% Modal_result = Wmat(invMapping,:);
% 
% vi = reshape(Modal_result(:,8),3,[])';
% % 
% ModalValueMat = zeros(size(vi,1),size(vi,2),length(Modes));
% for itr = 1:length(Modes)
%     vi = reshape(Modal_result(:,Modes(itr)),3,[])';
%     ModalValueMat(:,:,itr) = vi;
% end
% 
% plot(ModalValueMat(:,3,100))
% 
% plot(MatA(:,4,11))

% ModalValueMat = Modal_result(:,2:end,:);

%% ֱ�Ӷ�ȡģ̬���� ----------------

% ModalValueMat = MatA(:,2:end,:);   % [�ڵ�����3������]
% EigValues = Freqs;


%% ���������Ƭ -------------- ����������

% outside_faces = load_3mesh_from_ANSYS(Solid);

%% ���������Ƭ-------------- �ı�������

outside_faces = load_4mesh_from_ANSYS(Solid);  % -------------------------->3


%% 

% 
% % sumFaces = sum(outside_faces,2);
% 
% % tempF = Faces(inds,:);
% 
% 
% % ȷ���ڲ���
% [a,b] = hist(Solid(:),1:max(Solid(:)));
% inside_nodes = b(a >= 8);
% 
% bools = zeros(size(Faces,1),1) == 1;
% for itr = 1:length(inside_nodes)
%     bools(Faces(:,1) == inside_nodes(itr)) = 1;
%     bools(Faces(:,2) == inside_nodes(itr)) = 1;
%     bools(Faces(:,3) == inside_nodes(itr)) = 1;
%     bools(Faces(:,4) == inside_nodes(itr)) = 1;
% end
% outside_faces1 = Faces(~bools,:);
% inFaces = Faces(bools,:);
% length(bools)-sum(bools)
%  

%% ��ֵ

% verts = Nodes(:,2:4);

%% ��ͼ
% plot3(Nodes(:,2),Nodes(:,3),Nodes(:,4),'.')      % nplot
% axis equal;
% axis([0 5 0 3 0 32]+[-2 2 -2 2 -2 2]*2);
% view(-35,53)

% Mode_num = 20;       % ׼�����Ƶ�ģ̬����
% % plot3_DisplaceModel(ModalValueMat(:,:,Mode_num),outside_faces,Nodes,0)
% plot3_DisplaceModel(ModalValueMat(:,:,Mode_num),outside_faces,Nodes,100,1000,0)

% figure(10);clf
% hold on;
% col = 1;
% Mode_num = 7;
% plot(ModalValueMat(:,col,Mode_num))
% plot(-MatA(:,col+1,Mode_num),'r')

%% ���ӻ�
% TPhi = ModalValueMat(:,:,1);
% faces = outside_faces;
% verts = Nodes;
% 
% if size(verts,2) == 4
%     verts(:,1) = [];
% end

% modeNums = ones(1,3)*20;
% LengthBeam = 32.5+0.2;
% 
% clear BeamObject
% for itr = 1:length(modeNums)
%     BeamObject(itr).TPhi = ModalValueMat(:,:,modeNums(itr)); 
%     BeamObject(itr).coeff_Plot = 0;
%     BeamObject(itr).faces = outside_faces;
%     BeamObject(itr).verts = Nodes(:,2:4);
%     BeamObject(itr).verts(:,3) = BeamObject(itr).verts(:,3)+LengthBeam*(itr);
% end
% 
%  
% [hfig, BeamObject] = get_muti_objects3D(BeamObject);
% 
% DefScale = 200;
% dt = 0.1;
% % coeff_Plot = 0;
% for itr = 1:1000
% %     disp(sin(ii)) 
% %     coeff_Plot = itr*dt;
%     for jtr = 1:length(BeamObject)
%         BeamObject(jtr).coeff_Plot = rem(itr*dt,2*pi);
%     end
%     update_figure3D(BeamObject,DefScale,0)
% end













