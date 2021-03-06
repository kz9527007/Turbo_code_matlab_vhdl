% file name:    tbcdec.m
% description:  [dec_out,LLR] = tbcdec(r,iter,intlv,Lc) performs decoding for the example turbo code (rate-1/3, rsc = (1 5/7)),
%               where r represents the received sequence, iter specifies the decoding iterations, intlv is the permutation function
%               of the interleaver. the channel condition, Lc, must also be given. the function returns the hard-decision decoded output,
%               dec_out, and the corresponding llr, LLR.
% algorithm:    logmap/maxlogmap decoding algorithm
% author:       y. jiang
% date:         june 2010
% revision:     1.0


function [dec_out,LLR] = tbcdec(r1,r2,r3,iter,intlv,Lc)

dec_out = zeros(1,8);
LLR = zeros(1,8);

r = [r1,r2,r3];
% demultiplex r into 3 subsequences
rs = r(:,1);                                        % systematic bit
r1 = r(:,2);                                        % parity bit 1
r2 = r(:,3);                                        % parity bit 2

nn = 8;
%
% LLR = zeros(1,8);
% Le  = zeros(1,8);
%
% a1 = zeros(1,9);
% a2 = zeros(1,9);
% a3 = zeros(1,9);
% a4 = zeros(1,9);
% b1 = zeros(1,9);
% b2 = zeros(1,9);
% b3 = zeros(1,9);
% b4 = zeros(1,9);
% g1 = zeros(1,8);
% g2 = zeros(1,8);
% g3 = zeros(1,8);
% g4 = zeros(1,8);
% g5 = zeros(1,8);
% g6 = zeros(1,8);
% g7 = zeros(1,8);
% g8 = zeros(1,8);
p = intlv;                                          % intlv's permutation function

Le = zeros(1,nn);                                   % initial extrinsic probability


for k = 1:iter


    LLR = zeros(1,8);
    if mod(k,2)                                    % odd numbered iter.
        r_temp1 = [rs r1];
%         r_temp2 = reshape(r_temp1',1,2*nn);
        r_temp2 = [r_temp1(1,1) r_temp1(1,2) r_temp1(2,1) r_temp1(2,2) r_temp1(3,1) r_temp1(3,2) r_temp1(4,1) r_temp1(4,2) r_temp1(5,1) r_temp1(5,2) r_temp1(6,1) r_temp1(6,2) r_temp1(7,1) r_temp1(7,2) r_temp1(8,1) r_temp1(8,2)];        
        Le(p) = Le;                                 % de-interleave
    else                                            % even numbered iter.
        rs = rs(p);                                 % interleave
        r_temp1 = [rs r2];
        r_temp2 = [r_temp1(1,1) r_temp1(1,2) r_temp1(2,1) r_temp1(2,2) r_temp1(3,1) r_temp1(3,2) r_temp1(4,1) r_temp1(4,2) r_temp1(5,1) r_temp1(5,2) r_temp1(6,1) r_temp1(6,2) r_temp1(7,1) r_temp1(7,2) r_temp1(8,1) r_temp1(8,2)];
        Le = Le(p);                                 % interleave
    end


%begin of logmap function
% function [LLR,a,b,g,Le] = logmap(r,ap,Lc_logmap)


r_logmap = r_temp2;
ap_logmap = Le;
Lc_logmap  = Lc;



rs_logmap = r_logmap(1:2:end-1);                                          % extract systematic bits
r_logmap = repmat(r_logmap,8,1);

% nn_logmap = length(rs_logmap);
nn_logmap = 8;

% if ap_logmap == 0
%     ap_logmap = zeros(1,nn_logmap);
% end

La = ap_logmap;
Le = ap_logmap';
sp = zeros(1,8);
sm = zeros(1,8);
LLR = zeros(1,8);


c = [1,1; -1,-1; -1,-1; 1,1; -1,1; 1,-1; 1,-1; -1,1];                       % list of codewords in a trellis (pay attention to the order)

g = zeros(8,8);                                                             % g: gamma
k = 1;
for i=1:2:15                                                                % compute gamma. eq.(6.30)
    g(:,k) = 0.5*Lc_logmap*(c(:,1).*r_logmap(:,i) + c(:,2).*r_logmap(:,i+1)) + 0.5*c(:,1).*Le(k);
    k = k + 1;
end


g1 = g([1 3 2 4 5 7 6 8],:);                                                % re-order gamma to ficilitate alpha calculation below
a = -1e10*ones(4,9); a(1,1) = 0;                                            % a: alpha. initialization
for i = 2:9                                                                 % compute alpha. eq.(6.29) and (6.36)
    a1 = g1(1,i-1) + a(1,i-1); a2 = g1(2,i-1) + a(3,i-1);
    a(1,i) = max(a1,a2) + call_custom_log(1+call_custom_exp(-abs(a1-a2)));

    a1 = g1(3,i-1) + a(1,i-1); a2 = g1(4,i-1) + a(3,i-1);
    a(2,i) = max(a1,a2) + call_custom_log(1+call_custom_exp(-abs(a1-a2)));

    a1 = g1(5,i-1) + a(2,i-1); a2 = g1(6,i-1) + a(4,i-1);
    a(3,i) = max(a1,a2) + call_custom_log(1+call_custom_exp(-abs(a1-a2)));

    a1 = g1(7,i-1) + a(2,i-1); a2 = g1(8,i-1) + a(4,i-1);
    a(4,i) = max(a1,a2) + call_custom_log(1+call_custom_exp(-abs(a1-a2)));
end

b = -1e10*ones(4,9); b(1,end) = 0;               % b: beta. initialization
for i = 8:-1:1                                    % compute beta. eq.(6.29) and (6.36)
    b1 = g(1,i) + b(1,i+1); b2 = g(2,i) + b(2,i+1);
    b(1,i) = max(b1,b2) + call_custom_log(1+call_custom_exp(-abs(b1-b2)));

    b1 = g(5,i) + b(3,i+1); b2 = g(6,i) + b(4,i+1);
    b(2,i) = max(b1,b2) + call_custom_log(1+call_custom_exp(-abs(b1-b2)));

    b1 = g(3,i) + b(1,i+1); b2 = g(4,i) + b(2,i+1);
    b(3,i) = max(b1,b2) + call_custom_log(1+call_custom_exp(-abs(b1-b2)));

    b1 = g(7,i) + b(3,i+1); b2 = g(8,i) + b(4,i+1);
    b(4,i) = max(b1,b2) + call_custom_log(1+call_custom_exp(-abs(b1-b2)));
end

for i=1:nn_logmap                                                  % compute LLR. eq.(6.31) and (6.36)                                                   %
    spa = a(1,i) + g(1,i) + b(1,i+1); spb = a(3,i) + g(4,i) + b(2,i+1);
    sp1 = max(spa,spb) + call_custom_log(1+call_custom_exp(-abs(spa-spb)));

    spa = a(2,i) + g(6,i) + b(4,i+1); spb = a(4,i) + g(7,i) + b(3,i+1);
    sp2 = max(spa,spb) + call_custom_log(1+call_custom_exp(-abs(spa-spb)));

    sp(i) = max(sp1,sp2) + call_custom_log(1+call_custom_exp(-abs(sp1-sp2)));

    sma = a(1,i) + g(2,i) + b(2,i+1); smb = a(3,i) + g(3,i) + b(1,i+1);
    sm1 = max(sma,smb) + call_custom_log(1+call_custom_exp(-abs(sma-smb)));

    sma = a(2,i) + g(5,i) + b(3,i+1); smb = a(4,i) + g(8,i) + b(4,i+1);
    sm2 = max(sma,smb) + call_custom_log(1+call_custom_exp(-abs(sma-smb)));

    sm(i) = max(sm1,sm2) + call_custom_log(1+call_custom_exp(-abs(sm1-sm2)));
end


% a1 = a(1,:);
% a2 = a(2,:);
% a3 = a(3,:);
% a4 = a(4,:);
%
% b1 = b(1,:);
% b2 = b(2,:);
% b3 = b(3,:);
% b4 = b(4,:);
%
% g1 = g(1,:);
% g2 = g(2,:);
% g3 = g(3,:);
% g4 = g(4,:);
% g5 = g(5,:);
% g6 = g(6,:);
% g7 = g(7,:);
% g8 = g(8,:);


LLR = sp - sm;

Le = LLR - Lc_logmap*rs_logmap - La;                                      % comupte Le.
%logmap function end


%     %hdl coder doesn't like functions with arrays for io
%     [LLR,a1,a2,a3,a4,b1,b2,b3,b4,g1,g2,g3,g4,g5,g6,g7,g8,Le] = hdl_logmap(r,Le,Lc_logmap);               % logmap algorithm
%
%     a = [a1; a2 ;a3; a4];
%     b = [b1; b2; b3; b4];
%     g = [g1; g2; g3; g4; g5; g6; g7; g8];
dec_out = sign(LLR);

end

    %[LLR,a,b,g,Le] = maxlogmap(r,Le,Lc);            % maxlogmap algorithm
% end
