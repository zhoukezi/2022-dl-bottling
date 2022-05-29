module StatusController (
    input logic clk,
    input logic reset_n,
    input logic flip_working,
    input logic shift_selection,
    output logic working,
    output logic[4:0] selection
);

    logic working_next;
    logic[4:0] selection_shifted;
    logic[4:0] selection_next;

    always_ff @(posedge clk, negedge reset_n)
        if (reset_n == '0) begin
            working <= '0;
            selection <= 5'b00010;
        end
        else begin
            working <= working_next;
            selection <= selection_next;
        end

    assign working_next = working ^ flip_working;

    always_comb
        if (shift_selection) begin
            if (working_next)
                selection_shifted = {selection[0], selection[4:1]};
            else
                selection_shifted = {3'd0, selection[0], selection[1]};
        end
        else
            selection_shifted = selection;

    always_comb
        if (working_next)
            selection_next = selection_shifted;
        else
            case (selection_shifted)
                5'b10000: selection_next = 5'b00010;
                5'b01000: selection_next = 5'b00010;
                5'b00100: selection_next = 5'b00001;
                default:  selection_next = selection_shifted;
            endcase

endmodule
