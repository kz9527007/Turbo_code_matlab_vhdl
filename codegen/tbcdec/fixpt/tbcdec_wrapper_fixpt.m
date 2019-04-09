%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                          %
%           Generated by MATLAB 9.5 and Fixed-Point Designer 6.2           %
%                                                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [dec_out,LLR] = tbcdec_wrapper_fixpt(r1,r2,r3,iter,intlv,Lc)
    fm = get_fimath();
    r1_in = fi( r1, 1, 16, 11, fm );
    r2_in = fi( r2, 1, 16, 12, fm );
    r3_in = fi( r3, 1, 16, 12, fm );
    iter_in = fi( iter, 0, 8, 0, fm );
    intlv_in = fi( intlv, 0, 8, 0, fm );
    Lc_in = fi( Lc, 0, 16, 11, fm );
    [dec_out_out,LLR_out] = tbcdec_fixpt( r1_in, r2_in, r3_in, iter_in, intlv_in, Lc_in );
    dec_out = double( dec_out_out );
    LLR = double( LLR_out );
end

function fm = get_fimath()
	fm = fimath('RoundingMethod', 'Floor',...
	     'OverflowAction', 'Wrap',...
	     'ProductMode','FullPrecision',...
	     'SumMode','FullPrecision');
end