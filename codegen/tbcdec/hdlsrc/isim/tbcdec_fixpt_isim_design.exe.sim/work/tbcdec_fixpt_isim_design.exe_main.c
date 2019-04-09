/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

#include "xsi.h"

struct XSI_INFO xsi_info;

char *STD_STANDARD;
char *STD_TEXTIO;
char *IEEE_P_2592010699;
char *IEEE_P_3564397177;
char *XLIB_P_2727132835;
char *IEEE_P_1242562249;
char *XLIB_P_1141962721;


int main(int argc, char **argv)
{
    xsi_init_design(argc, argv);
    xsi_register_info(&xsi_info);

    xsi_register_min_prec_unit(-12);
    std_textio_init();
    ieee_p_2592010699_init();
    ieee_p_3564397177_init();
    ieee_p_1242562249_init();
    xlib_p_2727132835_init();
    xlib_p_1141962721_init();
    xlib_a_2858860645_1516540902_init();
    xlib_a_3868586038_1516540902_init();


    xsi_register_tops("xlib_a_3868586038_1516540902");

    STD_STANDARD = xsi_get_engine_memory("std_standard");
    STD_TEXTIO = xsi_get_engine_memory("std_textio");
    IEEE_P_2592010699 = xsi_get_engine_memory("ieee_p_2592010699");
    xsi_register_ieee_std_logic_1164(IEEE_P_2592010699);
    IEEE_P_3564397177 = xsi_get_engine_memory("ieee_p_3564397177");
    XLIB_P_2727132835 = xsi_get_engine_memory("xlib_p_2727132835");
    IEEE_P_1242562249 = xsi_get_engine_memory("ieee_p_1242562249");
    XLIB_P_1141962721 = xsi_get_engine_memory("xlib_p_1141962721");

    return xsi_run_simulation(argc, argv);

}
