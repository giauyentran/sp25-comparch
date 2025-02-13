// Finite State Machine
// Based on iceBlinkPico/examples/fsm/fsm.sv

module fsm #(
    parameter BLINK_INTERVAL = 2000000,     // CLK freq is 12MHz, so 2,000,000 cycles through 6 intervals in 1s
)(
    input logic     clk, 
    output logic    red, 
    output logic    yellow,
    output logic    green, 
    output logic    cyan,
    output logic    blue,
    output logic    magenta,
);

    // Define state variable values
    localparam RED = 3'b010;
    localparam YELLOW = 3'b011;
    localparam GREEN = 3'b000;
    localparam CYAN = 3'b101;
    localparam BLUE = 3'b001;
    localparam MAGENTA = 3'b100;

    // Declare state variables
    logic [2:0] current_state = RED;
    logic [2:0] next_state;

    // Declare next output variables
    logic next_red, next_yellow, next_green, next_cyan, next_blue, next_magenta;

    // Declare counting variable for timing
    logic [$clog2(BLINK_INTERVAL) - 1:0] count = 0;

    // Change states when interval elapses
    always_ff @(posedge clk) begin
        if (count == BLINK_INTERVAL - 1) begin
            count <= 0;
            current_state <= next_state;
        end
        else begin
            count <= count + 1;
        end
    end

    // Compute the next state of the FSM
    always_comb begin
        next_state = 3'bxxx;
        case (current_state)
            RED:
                next_state = YELLOW;
            YELLOW:
                next_state = GREEN;
            GREEN:
                next_state = CYAN;
            CYAN:
                next_state = BLUE;
            BLUE:
                next_state = MAGENTA;
            MAGENTA:
                next_state = RED;
        endcase
    end

    // Register the FSM outputs
    always_ff @(posedge clk) begin
        red <= next_red;
        yellow <= next_yellow;
        green <= next_green;
        cyan <= next_cyan;
        blue <= next_blue;
        magenta <= next_magenta;
    end

    // Compute next output values
    always_comb begin
        next_red = 1'b0;
        next_green = 1'b0;
        next_blue = 1'b0;
        next_yellow = 1'b0;
        next_magenta = 1'b0;
        next_cyan = 1'b0;

        case (current_state)
            RED:
                next_red = 1'b1;
            YELLOW:
                begin
                    next_red = 1'b1;
                    next_green = 1'b1; 
                    next_yellow = 1'b1;
                end
            GREEN:
                next_green = 1'b1;
            CYAN:
                begin
                    next_blue = 1'b1;
                    next_green = 1'b1;
                    next_cyan = 1'b1;
                end
            BLUE:
                next_blue = 1'b1;
            MAGENTA:
                begin
                    next_blue = 1'b1;
                    next_red = 1'b1;
                    next_magenta = 1'b1;
                end
        endcase
    end


endmodule

