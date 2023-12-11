clc
clear all
close all
format short


%This program will solve 1D Heat Transfer through a bar

%inputs

T_A=0 ;%input('please specify the temperature at left \n')  %Bounndary condition
T_B=100; %input('please specify the temperature at Right \n')  %Boundary condition
k=100; %input('please specify the Conductivity \n')
node=10;  %input('please specify the number of nodes \n')
L=100; %input('please specify the Length  of the wire \n')
S=10; %input('Heat generation rate in the wire \n')

%properties

         d=(L./node); % length of each node
         D=k/d;
         A=0.1;
         V=A*d;

coe=zeros(node); %coeficient matrix

%solving to get the temperature at nodes
for n= 1:node

    if n==1



        a_L=0;
        a_R=D.*A;
        S_p=-2.*D.*A;
        S_u=T_A.*(2.*D.*A)+(S.*V);
        a_p=a_L+a_R-S_p;


        coe(n,n)=a_p;
        coe(n,n+1)=-a_R;

        ans(n,1)=S_u;

    elseif n==node


        a_R=0;
        a_L=D.*A;
        S_p=-2.*D.*A;
        S_u=T_B.*(2.*D.*A)+(S.*V);
        a_p=a_L+a_R-S_p;


        coe(n,n)=a_p;
        coe(n,n-1)=-a_L;
        ans(n,1)=S_u;

    elseif n>1 & n<node



            S_p=0;
            S_u=S.*V;
            a_R=A.*D;
            a_L=A.*D;
            a_p=a_L+a_R-S_p;

        coe(n,n-1)=-a_L;
        coe(n,n)=a_p;
        coe(n,n+1)=-a_R;

        ans(n,1)=S_u;

    end


end
Temperature_Dist=coe\ans;
% syms T [1 node]
z=1;
%%while z<=node
%    ch_Answer=num2str(Temperature_Dist(z)); %we nee d to change the  type of data to avoid error
%temperature=[T(z),'is',ch_Answer]; %How to show multiple variables in one line using disp
%disp (temperature)
%z=z+1;
%end

%plotting discrete points and analytical results for comparison
i=1;
x_value=zeros(node,1);
y_value=zeros(node,1);
while i<=node
    x1=(d./2)+(i-1).*(d);
    y1=Temperature_Dist(i);
    x_value(i)=x1;
    y_value(i)=y1;
    i=i+1;
end
    plot(x_value,y_value,'*','MarkerSize',10);
    hold on
    x=0:0.05:L;
    analytical_T=T_A+(x.*(T_B-T_A)./L)+(S.*x.*(L-x))./(2.*k);
    plot(x,analytical_T)


    %comparing the results
    i=1;
    matrix_of_analytical_T=zeros(node,1);
    while i<=node
        x=x_value(i);
         matrix_of_analytical_T(i)=T_A+(x.*(T_B-T_A)./L)+(S.*x.*(L-x))./(2.*k);
         i=i+1;
    end
    f= matrix_of_analytical_T;
    table(x_value, y_value, f,  (f-y_value).^2,'VariableNames',{'X','TEMP','Analytical_Temp','Square_of_ERROR'})
