%kör main först
load('bassh3-E.mat')

Xmodel = eres.x;
p = eres.y;
t = ematches.utimes;%enklare att använda ematches.uindex...
load('plane')

r = 1; %obs! har bara tillgång till r = 1
k = 2;

ur = sqrt(sum((repmat(Xmodel(:,r),1,size(p,2))-p).^2));
uk = sqrt(sum((repmat(Xmodel(:,k),1,size(p,2))-p).^2));

urk = uk-ur;

close all
fig = figure;

%direkt:
imagesc(gccScores{k}),colormap(gray)
hold on
x = round(t/length(a)*1000*settings.sr);
y = urk*settings.sr/settings.v+settings.sw;
plot(x,y,'--')

%speglad:
mkspeglad = Xmodel(:,k)-2*dot(Xmodel(:,k)-po,n)*n;
ukspeglad = sqrt(sum((repmat(mkspeglad,1,size(p,2))-p).^2));

urks = ukspeglad-ur;
x = round(t/length(a)*1000*settings.sr);
y = urks*settings.sr/settings.v+settings.sw;
hold on
hs = plot(x,y,'g--');

%speglad2:
mrspeglad = Xmodel(:,r)-2*dot(Xmodel(:,r)-po,n)*n;
urspeglad = sqrt(sum((repmat(mrspeglad,1,size(p,2))-p).^2));
ukrs = uk-urspeglad;
x = round(t/length(a)*1000*settings.sr);
y = ukrs*settings.sr/settings.v+settings.sw;
hs2 = plot(x,y,'r--');

%källaspeglad:
ps = p-2*repmat(dot(p-repmat(po,1,size(p,2)),repmat(n,1,size(p,2))),3,1).*repmat(n,1,size(p,2));
ur = sqrt(sum((repmat(Xmodel(:,r),1,size(p,2))-ps).^2));
uk = sqrt(sum((repmat(Xmodel(:,k),1,size(p,2))-ps).^2));
urk = uk-ur;
x = round(t/length(a)*1000*settings.sr);
y = urk*settings.sr/settings.v+settings.sw;
hs3 = plot(x,y,'m--');

% %test: (att spegla både u och r är samma sak som att spegla källan)
% uuuu = ukspeglad-urspeglad;
% x = round(t/length(a)*1000*settings.sr);
% y = uuuu*settings.sr/settings.v+settings.sw;
% hs4 = plot(x,y,'yo');

legend('direct','k mirrored','r mirrored','source mirroed')

while ishandle(fig)
    if ~ishandle(fig), break, end
    set(hs,'Visible','on')
    set(hs2,'Visible','on')
    set(hs3,'Visible','on')
    %set(hs4,'Visible','on')
    pause(1)
    if ~ishandle(fig), break, end
    set(hs,'Visible','off')
    set(hs2,'Visible','off')
    set(hs3,'Visible','off')
    %set(hs4,'Visible','off')
    pause(1)
end