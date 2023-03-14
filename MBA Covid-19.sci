//clear 


N=100
for n=1:N do



warning('off')



//TRANSITION MATRICES

//Morning to afternoon transition at saturday
L12Tsat=[0.6158 0.0354 0.0163 0.0109 0.0409 0.2807;
          0.4286 0.3393 0.0000 0.0179 0.0714 0.1428;
          0.2033 0.0081 0.6829 0.0163 0.0488 0.0406;
          0.3871 0.0000 0.0645 0.1290 0.0323 0.3871;
          0.5085 0.0169 0.0339 0.0508 0.2373 0.1526;
          0.3153 0.0000 0.0180 0.0000 0.0360 0.6307;]
   
//Afternoon to night  transition at saturday
L23Tsat=[0.9318 0.0000 0.0114 0.0085 0.0114 0.0369;
          0.8529 0.0000 0.0588 0.0588 0.0000 0.0295;
          0.7708 0.0104 0.1667 0.0208 0.0000 0.0313;
          0.8571 0.0000 0.1429 0.0000 0.0000 0.0000;
          0.8182 0.0000 0.0227 0.0000 0.0909 0.0682;
          0.7729 0.0000 0.0000 0.0097 0.0048 0.2126;]
      
//Morning to afternoon transition at sunday
L12Tsun=[0.9356 0.0072 0.0024 0.0119 0.0000 0.0429;
          0.7778 0.1111 0.0370 0.0370 0.0000 0.0371;
          0.7258 0.0484 0.1452 0.0484 0.0322 0.0000;
          0.8400 0.0000 0.0000 0.0600 0.0200 0.0800;
          0.7813 0.0000 0.0000 0.0938 0.0000 0.1249;
          0.7707 0.0064 0.0000 0.0000 0.0064 0.2165;]

//Afternoon to night  transition at sunday
L23Tsun=[0.2647 0.2276 0.1099 0.3978 0.0000 0.0000;
          0.1000 0.2000 0.1000 0.6000 0.0000 0.0000;
          0.1818 0.1818 0.0909 0.5455 0.0000 0.0000;
          0.1333 0.2000 0.0000 0.6667 0.0000 0.0000;
          0.0000 0.2500 0.2500 0.5000 0.0000 0.0000;
          0.0492 0.3443 0.0820 0.5245 0.0000 0.0000;]

//Morning to afternoon transition at weekdays
L12Twd=[0.4695 0.3118 0.0430 0.0072 0.0179 0.1506;
         0.5000 0.2113 0.0423 0.0000 0.0211 0.2253;
         0.1038 0.0047 0.7689 0.0047 0.0047 0.1132;
         0.2500 0.0000 0.0000 0.2500 0.5000 0.0000;
         0.4828 0.0690 0.0345 0.0000 0.2759 0.1378;
         0.2840 0.1111 0.1358 0.0000 0.0370 0.4321;]

//Afternoon to night  transition at weekdays
L23Twd=[0.9427 0.0229 0.0038 0.0153 0.0038 0.0115;
         0.9535 0.0000 0.0155 0.0233 0.0000 0.0077;
         0.8083 0.0155 0.1036 0.0104 0.0000 0.0622;
         1.0000 0.0000 0.0000 0.0000 0.0000 0.0000;
         0.9091 0.0000 0.0000 0.0909 0.0000 0.0000;
         0.7956 0.0146 0.0146 0.0073 0.0000 0.1679;]
         
         
         
     //CONTACT RATES MATRIX
    contact_rates=[
    2.53  2.53  2.53; //residence
    8.15  9.05  10.05; // school
    7.91  8.08  8.24; // workspace
    7.65  9.54  9.32; // worshipplace
    6.55  6.94  0.00; // market
    6.63  7.08  8.04;] //another places
    
       //SOCIAL DISTANCING

   s=0.5; // s represents the level of compliance with social distancing 
   //at the location i
contact_rates(3,:)=(1-s)*contact_rates(3,:);

 contact_rates(5,:)=(1-s)*contact_rates(5,:);

// Parameters values
N=747;dt=1/3;gama1=1/9.5;gama2=1/13.4;pi=1/(60*365);mu=1/(60*365);R0=ceil(0.0097*N);E0=ceil(0.0003*N);A0=ceil(0.0019*N);I0=ceil(0.0081*N);S0=N-R0-E0-A0-I0;sigma=1/5;lastday=51;//From 05.02.2021 to 07.03.2021
q=0.25; //For now, let's consider q as the transmission probability 

  //Initial Population
  P=[zeros(S0,5); ones(E0,5); 2*ones(A0,5);3*ones(I0,5); 4*ones(R0,5);];
P(:,1)=[1:N]; //Indivudual id
// P(:,1) Individual epidemiological status
    P(:,2)=floor(-(1/pi)*dt*log(rand(N,1))); // agent age
  P(:,3)=floor(-(1/pi)*log(rand(N,1))); // max age
 
// P(:,4) (location)
 
  inde=find(P(:,5)==1); // find exposed agents position
  ninde=length(inde); // number of exposed
  P(inde,6)=floor(-(1/sigma)*dt*log(rand(ninde,1))); // latency period
  P(inde,7)=floor(-(1/sigma)*log(rand(ninde,1))); // max of latency period
  
  
    indfa=find(P(:,5)==2);  // find infeccious assintomatic agents position
  nindfa=length(indfa); // number of infeccious
  P(indfa,8)=floor(-(1/gama1)*dt*log(rand(nindfa,1))); // infeccious period
  P(indfa,9)=floor(-(1/gama1)*log(rand(nindfa,1))); // max to recovery
  
  indfs=find(P(:,5)==3);  // find infeccious sintomatic agents position
  nindfs=length(indfs); // number of infeccious
  P(indfs,8)=floor(-(1/gama2)*dt*log(rand(nindfs,1))); // infeccious period
  P(indfs,9)=floor(-(1/gama2)*log(rand(nindfs,1))); // max to recovery

  
    indr=find(P(:,5)==4);  // find recovered agents position
    nindr=length(indr); // number of recovered

  
  //S,E,A,I,R initial
  S(1,1) = sum(P(:,5)==0);
  E(1,1) = sum(P(:,5)==1);
  A(1,1) = sum(P(:,5)==2);
  I(1,1) = sum(P(:,5)==3);  
  R(1,1) = sum(P(:,5)==4);


for k = 1:lastday;  //Process until last day (day=k )
    
    //SPATIAL DYNAMIC
    
    dw = modulo(k, 7)+1;
    
    // setup movement probabilities
    if (dw == 7) then  // Saturday
        x0 = grand(1, size(P,'r'), "uin", 4, 6)';  
        L12 = L12Tsat;
        L23 = L23Tsat;
    elseif (dw == 1) then  // Sunday
        x0 = grand(1, size(P,'r'), "uin", 4, 6)';
        L12 = L12Tsun;
        L23 = L23Tsun;
    else          //Weekdays
        x0 = grand(1, size(P,'r'), "uin", 1, 3)';
        L12 = L12Twd;
        L23 = L23Twd;
    end
   
   
   //OPENING PACE
 h1=2; //(h represents locations away from residence)
 L12(:,1)=L12(:,1)+L12(:,h1);
L12(:,h1)=0; //(location h is closed)
 L23(:,1)=L23(:,1)+L23(:,h1);
L23(:,h1)=0; //(location h is closed)

   //OPENING PACE
 h5=3; //(h represents locations away from residence)
 L12(:,1)=L12(:,1)+0.1*L12(:,h5);
 L12(:,h5)=0.9*L12(:,h5); //(location h is closed)
 L23(:,1)=L23(:,1)+0.1*L23(:,h5);
 L23(:,h5)=0.9*L23(:,h5); //(location h is closed)

   //OPENING PACE
 h2=4; //(h represents locations away from residence)
 L12(:,1)=L12(:,1)+L12(:,h2);
L12(:,h2)=0; //(location h is closed)
 L23(:,1)=L23(:,1)+L23(:,h2);
L23(:,h2)=0; //(location h is closed)


   //OPENING PACE
 h3=6; //(h represents locations away from residence)
 L12(:,1)=L12(:,1)+L12(:,h3);
L12(:,h3)=0; //(location h is closed)
 L23(:,1)=L23(:,1)+L23(:,h3);
L23(:,h3)=0; //(location h is closed)


    // set initial locations
  for j=1:3 //Process in each period of k day
        if (j==1) then
    current_location_state = x0;
    P(:,4) = x0;  
    // disease dynamic in the morning

        elseif (j==2) then
    // L1-L2 move
    current_location_state = grand(1, 'markov', L12, current_location_state);
    P(:,4)=current_location_state;
    // disease dynamic in the afternoon 
    
        else
    // L2-L3 move
    current_location_state = grand(1, 'markov', L23, current_location_state);
    P(:,4) = current_location_state;
    // disease dynamic in the night
    end
    

  //DISEASE DYNAMIC
  

    //*****Death and replacement by a new birth*****
    indd=find(P(:,2)>P(:,3)); // find death agents
    P(indd,2)=0;             // new birth
    P(indd,3)=floor(-(1/pi)*log(rand(1)));// max age for new birth

        //*****Recover*****
    indr=find(P(:,8)>P(:,9));
    P(indr,5)=4;
    P(indr,6:9)=0;
 
    

         //*****Make infectious*****
  // indf=find(P(:,6)>P(:,7))
   // P(indf,5)=2;
   // P(indf,6:8)=0;
   // P(indf,9)=-(1/gama)*log(rand(1));  
   
     //Adding dt to latency time 
   inde=find(P(:,5)==1);
   if (P(inde,6)<P(inde,7)) then
   P(inde,6)=P(inde,6)+dt;
      elseif (rand(1)<0.87) then
         P(inde,5)=3;
          P(inde,6:8)=0;
    P(inde,9)=-(1/gama2)*log(rand(1));
       else
    P(inde,5)=2;
 P(inde,6:8)=0;
    P(inde,9)=-(1/gama1)*log(rand(1));
   end
    
       indfa=find(P(:,5)==2);
   P(indfa,8)=P(indfa,8)+dt;
   
          indfs=find(P(:,5)==3);
   P(indfs,8)=P(indfs,8)+dt;   
   

     //cl=contact_rate_at_current_location
     cl=contact_rates(current_location_state,j);
    betaI=cl*q*dt;

 
 
    N(k+1)=size(P,1);
    //*****Make Exposed*****
    for kk = 1:N(k+1)
      if P(kk,5)==0 then
	//Stochastic chosen of an individual
	ind = ceil(rand(1)*N(k+1));
	if ind ~= kk   //Except the same individual kk
	  if (P(ind,5)==2 | P(ind,5)==3)  & rand(1) > (1-betaI) then
	    P(kk,5)=1;        
            P(kk,6)=0;        
            P(kk,7)=floor(-(1/sigma)*log(rand(1)));        
	  end // if P(ind,        
	end // if ind ~= kk
      end // if P(kk,        
    end;   // for kk=1:N


   
   //Individuals getting old
   P(:,2)=P(:,2)+dt;
   
     //Number of S, E, A, I, R
   S(1,k+1) = sum(P(:,5)==0);
   E(1,k+1) = sum(P(:,5)==1);
   A(1,k+1) = sum(P(:,5)==2);
   I(1,k+1) = sum(P(:,5)==3);
   R(1,k+1) = sum(P(:,5)==4);
   [S($),E($),A($),I($),R($),k];

end

end

 Nt=N;


//Plot
t=linspace(1,lastday,lastday+1)
//subplot(511),plot(t,S,'r'),xlabel("Tempo t em dias a partir de 05 de Feveiro de 2021"),ylabel("S")
//subplot(512),plot(t,E,'r'),xlabel("Tempo t em dias a partir de 05 de Feveiro de 2021"),ylabel("E")
//subplot(513),plot(t,A,'r'),xlabel("Tempo t em dias a partir de 05 de Feveiro de 2021"),ylabel("A")
//subplot(514),plot(t,I,'r'),xlabel("Tempo t em dias a partir de 05 de Feveiro de 2021"),ylabel("I")
//subplot(515),plot(t,R,'r'),xlabel("Tempo t em dias a partir de 05 de Feveiro de 2021"),ylabel("R")

//plot(t,S,'b')
//plot(t,E,'m')  
//plot(t,A,'black')
plot(t,0.035*I/size(P,1),'c')
//plot(t,R,'g') 
//legend('S','E','A','I','R')
//title('Grafico do modelo ABM em SEAIR')
//xlabel('Tempo t em dias a partir de 15 de Janeiro')
//ylabel('População')

//plot(t,A,'--black') 

//https://x-engineer.org/scilab-plot-tutorial-1/ 

//https://brilliant.org/wiki/markov-chains/



    Sim(n,:)=I(1,:) // Vector que armazena cada simulacao
    Pic(n)=min(find(Sim(n,:)==max(Sim(n,:)))) // Indices/posicoes em dias de picos para cada simulacao
end

//Matriz que acumula os vectores/valores de cada simulacao
Matrixsimulations=[
Sim(1,:); Sim(2,:); Sim(3,:); Sim(4,:); Sim(5,:);Sim(6,:); Sim(7,:); Sim(8,:); Sim(9,:); Sim(10,:);
Sim(11,:); Sim(12,:); Sim(13,:); Sim(14,:); Sim(15,:);Sim(16,:); Sim(17,:); Sim(18,:); Sim(19,:); Sim(20,:);
Sim(21,:); Sim(22,:); Sim(23,:); Sim(24,:); Sim(25,:);Sim(26,:); Sim(27,:); Sim(28,:); Sim(29,:); Sim(30,:);
Sim(31,:); Sim(32,:); Sim(33,:); Sim(34,:); Sim(35,:);Sim(36,:); Sim(37,:); Sim(38,:); Sim(39,:); Sim(40,:);
Sim(41,:); Sim(42,:); Sim(43,:); Sim(44,:); Sim(45,:);Sim(46,:); Sim(47,:); Sim(48,:); Sim(49,:); Sim(50,:);
Sim(51,:); Sim(52,:); Sim(53,:); Sim(54,:); Sim(55,:);Sim(56,:); Sim(57,:); Sim(58,:); Sim(59,:); Sim(60,:);
Sim(61,:); Sim(62,:); Sim(63,:); Sim(64,:); Sim(65,:);Sim(66,:); Sim(67,:); Sim(68,:); Sim(69,:); Sim(70,:);
Sim(71,:); Sim(72,:); Sim(73,:); Sim(74,:); Sim(75,:);Sim(76,:); Sim(77,:); Sim(78,:); Sim(79,:); Sim(80,:);
Sim(81,:); Sim(82,:); Sim(83,:); Sim(84,:); Sim(85,:);Sim(86,:); Sim(87,:); Sim(88,:); Sim(89,:); Sim(90,:);
Sim(91,:); Sim(92,:); Sim(93,:); Sim(94,:); Sim(95,:);Sim(96,:); Sim(97,:); Sim(98,:); Sim(99,:); Sim(100,:);
]

Averageline=mean(Matrixsimulations,'r')// Linha media de todas simulacoes

plot(t,0.035*Averageline/size(P,1),'black','LineWidth',3) // Grafico da linha media
xlabel('Tempo (dias)','fontsize',3)
ylabel('Proporção dos infectados diagnosticados','fontsize',3)

//Vector dos indices dos picos
Vectorpicos=[Pic(1) Pic(2) Pic(3) Pic(4) Pic(5) Pic(6) Pic(7) Pic(8) Pic(9) Pic(10)
Pic(11) Pic(12) Pic(13) Pic(14) Pic(15) Pic(16) Pic(17) Pic(18) Pic(19) Pic(20)
Pic(21) Pic(22) Pic(23) Pic(24) Pic(25) Pic(26) Pic(27) Pic(28) Pic(29) Pic(30)
Pic(31) Pic(32) Pic(33) Pic(34) Pic(35) Pic(36) Pic(37) Pic(38) Pic(39) Pic(40)
Pic(41) Pic(42) Pic(43) Pic(44) Pic(45) Pic(46) Pic(47) Pic(48) Pic(49) Pic(50)
Pic(51) Pic(52) Pic(53) Pic(54) Pic(55) Pic(56) Pic(57) Pic(58) Pic(59) Pic(60)
Pic(61) Pic(62) Pic(63) Pic(64) Pic(65) Pic(66) Pic(67) Pic(68) Pic(69) Pic(70)
Pic(71) Pic(72) Pic(73) Pic(74) Pic(75) Pic(76) Pic(77) Pic(78) Pic(79) Pic(80)
Pic(81) Pic(82) Pic(83) Pic(84) Pic(85) Pic(86) Pic(87) Pic(88) Pic(89) Pic(90)
Pic(91) Pic(92) Pic(93) Pic(94) Pic(95) Pic(96) Pic(97) Pic(98) Pic(99) Pic(100)]
MinPic=min(Vectorpicos) //Dia de Pico mais cedo
MaxPic=max(Vectorpicos) //Dia de Pico mais atrasado
MediaPic=mean(Vectorpicos) //Dia medio de pico
MedianaPic=median(Vectorpicos) // Dia mediana de pico


f=tabul(Vectorpicos)
[num,m]=max(f(:,2))
ModaPic=f(m,1) //Dia modal de pico

ValPicAvL=max(0.035*Averageline/size(P,1))

PicAvL=find(0.035*Averageline/size(P,1)==ValPicAvL)

MedidasPic=[ValPicAvL PicAvL MinPic MaxPic MediaPic MedianaPic ModaPic]

