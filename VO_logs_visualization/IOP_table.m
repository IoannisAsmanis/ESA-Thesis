%%
clear args 
clear IFDs
clear IOPs

% args = cam, pitch, speed, period

args = { 
    {'loccam', 30.4, 0.07, 4.2857},
    {'navcam', 37.7, 0.07, 1.4286}};
args = { 
    {'loccam', 30.4, 0.07, 4.2857},
    {'navcam', 37.7, 0.07, 4.2857}};

% args = {
%     {'navcam', 20, 0.07, 4.2857},
%     {'navcam', 30, 0.07, 4.2857},
%     {'loccam', 30, 0.07, 4.2857},
%     {'navcam', 40, 0.07, 4.2857},
%     {'navcam', 50, 0.07, 4.2857}};
% %     {'navcam', 20, 0.07, 1},
% %     {'navcam', 30, 0.07, 1},
% %     {'navcam', 40, 0.07, 1},
% %     {'navcam', 50, 0.07, 1}};

% args = {
%     {'loccam', 30, 0.02, 0.5},
%     {'loccam', 30, 0.07, 0.428},
%     {'loccam', 30, 0.07, 1},
%     {'loccam', 30, 0.07, 1.42857},
%     {'loccam', 30, 0.07, 2.8571},
%     {'loccam', 30, 0.07, 4.2857},
%     {'loccam', 30, 0.07, 7.1428},
%     {'loccam', 30, 0.07, 10.7143},
%     {'loccam', 30, 0.07, 14.2857}};

% args = { % cam, pitch, speed, period
%     {'loccam', 30.4, 0.07, 4.2857},
%     {'navcam', 30.4, 0.07, 12},
%     {'loccam', 30.4, 0.07, 1.42875},
%     {'navcam', 30.4, 0.07, 3.5},    
%     {'loccam', 30.4, 0.07, 10.7143},
%     {'navcam', 30.4, 0.07, 28}};

% args = {
%     {'navcam', 20, 0.07, 5},
%     {'navcam', 30, 0.07, 5},
%     {'navcam', 40, 0.07, 5},
%     {'navcam', 50, 0.07, 5},
%     {'loccam', 30, 0.07, 5}};

% args = {
%     {'navcam', 20, 0.07, 1},
%     {'navcam', 30, 0.07, 1},
%     {'navcam', 40, 0.07, 1},
%     {'navcam', 50, 0.07, 1},
%     {'loccam', 50, 0.07, 1}};


for i = 1:size(args,1)
    args{i}{5} = args{i}{3}*args{i}{4};
    args{i}{6} = computeIOP(args{i}{1}, args{i}{2}, args{i}{3}, args{i}{4});
    IFDs(i) = args{i}{5};
    IOPs(i) = args{i}{6};
end

for i=1:size(args,1)
    args{i}
end
IFDs
IOPs