module pwm #(
    parameter int WIDTH = 10  // 10-bit PWM (1024 levels)
)(
    input  logic clk,
    input  logic [WIDTH-1:0] pwm_in,
    output logic pwm_out
);

    logic [WIDTH-1:0] counter = 0;

    always_ff @(posedge clk) begin
        counter <= counter + 1;
    end

    always_comb begin
        pwm_out = (counter < pwm_in);
    end

endmodule

