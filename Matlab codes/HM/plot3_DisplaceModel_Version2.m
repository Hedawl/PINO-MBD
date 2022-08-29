function plot3_DisplaceModel_Version2(hfig,p,TPhi,verts,DefScale,ifColorBar)

if nargin < 5
    ifColorBar = false;
end
if size(verts,2) == 4
    verts(:,1) = [];
end

%%

data.FaceVertexItem = 1;
data.DefScale = DefScale;
data.pause = false;
data.ModeChanged = false;

set( hfig, 'userdata', data );  % init displayed mode

dat = get( hfig, 'userdata' );  % ��ȡ����
u = TPhi.* ( dat.DefScale * 1 ); %
set( p, 'vertices', verts + u ); % �ı�ڵ�����
dispVector = dat.DefScale * sqrt( TPhi( :, 1 ) .^ 2 + TPhi( :, 2 ) .^ 2 + TPhi( :, 3 ) .^ 2 ); % �������ʸ��
faceVertexCData = GetVertCData2( dat.FaceVertexItem, dat.DefScale * TPhi, u, dispVector ) ; % ���㵱ǰ��������Ӧ����ɫֵ����������
set( p, 'FaceVertexCData', faceVertexCData , 'EdgeColor', 'interp' ); % ������ɫ��ʾ
if ifColorBar
    maxDef = max(u(:));
    maxDef = maxDef / dat.DefScale;
    tickLabel = 0 : maxDef / 10 : maxDef; % ����colorbar�̶Ȳ���ʾ
    colorbar( 'YTickLabel', { num2str( tickLabel( 1 ) ), num2str( tickLabel( 2 ) ), num2str( tickLabel( 3 ) ), ...
        num2str( tickLabel( 4 ) ), num2str( tickLabel( 5 ) ), num2str( tickLabel( 6 ) ), num2str( tickLabel( 7 ) ), ...
        num2str( tickLabel( 8 ) ), num2str( tickLabel( 9 ) ), num2str( tickLabel( 10 ) ), num2str( tickLabel( 11 ) ) } );
end
%     axis square equal auto off;




