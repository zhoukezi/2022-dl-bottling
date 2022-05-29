module Root (
    input logic clk,
    input logic reset_n,
    input logic[4:1] key_n,
    output logic[4:1] led_n,
    output logic ledsd_bl,
    output logic ledsd_ds,
    output logic ledsd_shcp,
    output logic ledsd_stcp,
    output logic buzzer
);
    genvar i;

    logic display_flicker;
    logic pill_pulse;

    Divider divider(
        .clk(clk),
        .reset_n(reset_n),
        .display_flicker(display_flicker),
        .pill_pulse(pill_pulse)
    );

    logic key_pulse[4:1];

    generate
        for (i = 1; i <= 4; i++) begin : gen_key_pulse
            PulseKey key_i(
                .clk(clk),
                .reset_n(reset_n),
                .key_n(key_n[i]),
                .pos_pulse(key_pulse[i])
            );
        end
    endgenerate

    logic[3:0] bcd[3:1];
    logic[7:0] digit_n[6:1];
    logic od;

    generate
        for (i = 4; i <= 6; i++) begin : gen_bcd
            assign digit_n[i] = '1;
        end
    endgenerate

    generate
        for (i = 1; i <= 3; i++) begin : gen_decoder
            BcdDecoder decoder_i(
                .bcd(bcd[i]),
                .led_seg_h_n(1'b1),
                .digit_n(digit_n[i])
            );
        end
    endgenerate

    DigitDisplay display(
        .clk(clk),
        .reset_n(reset_n),
        .od(od),
        .digit_n({
            digit_n[6],
            digit_n[5],
            digit_n[4],
            digit_n[3],
            digit_n[2],
            digit_n[1]
        }),
        .ledsd_bl(ledsd_bl),
        .ledsd_ds(ledsd_ds),
        .ledsd_shcp(ledsd_shcp),
        .ledsd_stcp(ledsd_stcp)
    );

    logic buzzer_en;

    Buzzer buzzer_coutroller(
        .clk(clk),
        .reset_n(reset_n),
        .en(buzzer_en),
        .buzzer(buzzer)
    );

    logic working;
    logic[4:0] selection;
    logic[7:0] bottle_setting;
    logic[7:0] pill_setting;
    SettingCounters setting_counters(
        .clk(clk),
        .reset_n(reset_n),
        .en(!working),
        .selection({selection[1], selection[0]}),
        .add_pulse(key_pulse[2]),
        .reset_pulse(key_pulse[3]),
        .bottle_setting(bottle_setting),
        .pill_setting(pill_setting)
    );

    logic[3:1] status;

    always_comb begin
        status = '0;
        case (selection)
            5'b10000: status[3] = '1;
            5'b01000: status[2] = '1;
            5'b00100: status[1] = '1;
            5'b00010: status[2] = display_flicker;
            5'b00001: status[1] = display_flicker;
            default: status = '1;
        endcase
    end

    logic oe;
    logic finished;

    BottlingCore core(
        .clk(clk),
        .reset_n(reset_n),
        .display_flicker(display_flicker),
        .pill_pulse(pill_pulse),
        .flip_working(key_pulse[4]),
        .shift_selection(key_pulse[1]),
        .bottle_setting(bottle_setting),
        .pill_setting(pill_setting),
        .bcd(bcd),
        .oe(oe),
        .selection(selection),
        .working(working),
        .finished(finished),
        .beep(buzzer_en)
    );

    assign od = !oe;
    assign led_n[3:1] = ~status;
    assign led_n[4] = !finished;

endmodule
