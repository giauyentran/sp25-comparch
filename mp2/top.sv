`include "pwm.sv"
`include "ramp.sv"

module top(
    input  logic clk,
    output logic RGB_R,
    output logic RGB_G,
    output logic RGB_B
);

    // 10-bit signals
    logic [9:0] ramp_r, ramp_g, ramp_b;
    logic pwm_r, pwm_g, pwm_b;

    localparam int CLK_FREQ = 12_000_000;
    localparam int STEPS = 360;
    localparam int STEP_DELAY = CLK_FREQ / STEPS;  // ~33_333 for 12MHz clock

    // Ramps with 120 deg phase shift
    ramp #(.WIDTH(10), .INIT_POS(0)) ramp_red (
        .clk(clk),
        .step_delay(STEP_DELAY),
        .ramp_out(ramp_r)
    );

    ramp #(.WIDTH(10), .INIT_POS(120)) ramp_green (
        .clk(clk),
        .step_delay(STEP_DELAY),
        .ramp_out(ramp_g)
    );

    ramp #(.WIDTH(10), .INIT_POS(240)) ramp_blue (
        .clk(clk),
        .step_delay(STEP_DELAY),
        .ramp_out(ramp_b)
    );

    pwm #(.WIDTH(10)) pwm_r_inst (
        .clk(clk),
        .pwm_in(ramp_r),
        .pwm_out(pwm_r)
    );

    pwm #(.WIDTH(10)) pwm_g_inst (
        .clk(clk),
        .pwm_in(ramp_g),
        .pwm_out(pwm_g)
    );

    pwm #(.WIDTH(10)) pwm_b_inst (
        .clk(clk),
        .pwm_in(ramp_b),
        .pwm_out(pwm_b)
    );

    assign RGB_R = pwm_r;
    assign RGB_G = pwm_g;
    assign RGB_B = pwm_b;

endmodule

