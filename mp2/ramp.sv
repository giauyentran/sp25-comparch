module ramp #(
    parameter int WIDTH = 10,
    parameter int INIT_POS = 0
)(
    input  logic clk,
    input  logic [21:0] step_delay,
    output logic [WIDTH-1:0] ramp_out
);

    logic [8:0] pos = INIT_POS;
    logic [21:0] counter = 0;

    always_ff @(posedge clk) begin
        counter <= counter + 1;
        if (counter >= step_delay) begin
            counter <= 0;
            pos <= (pos == 359) ? 0 : pos + 1;
        end
    end

    always_comb begin
        // Trapezoid fade
        if (pos < 60) begin
            ramp_out = pos * (1023/59);  // fade in
        end
        else if (pos < 180) begin
            ramp_out = 1023;             // hold high
        end
        else if (pos < 240) begin
            ramp_out = (239 - pos) * (1023/59); // fade out
        end
        else begin
            ramp_out = 0;                // hold low
        end
    end

endmodule