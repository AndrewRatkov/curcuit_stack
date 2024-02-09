module Stack(output reg ANS0, ANS1, ANS2, ANS3, input wire OP0, OP1, RESET, C, input wire[2:0] G, input wire[3:0] D);
    int Pointer = 0;
    int adress;
    reg[19:0] cells; 
    always @(*) begin
        case ({RESET})
            1'b0: begin
                case ({C})
                    1'b0: begin
                        ANS0 = 1'bZ; ANS1 = 1'bZ; ANS2 = 1'bZ; ANS3 = 1'bZ;
                    end
                    1'b1: begin
                        case ({OP1, OP0})
                            2'b00: begin // nop
                                ANS0 = 1'bZ; ANS1 = 1'bZ; ANS2 = 1'bZ; ANS3 = 1'bZ;
                            end
                            2'b01: begin // push
                                cells[Pointer * 4 + 0] = D[0];
                                cells[Pointer * 4 + 1] = D[1];
                                cells[Pointer * 4 + 2] = D[2];
                                cells[Pointer * 4 + 3] = D[3];
                                Pointer = (Pointer + 1) % 5;
                                ANS0 = 1'bZ; ANS1 = 1'bZ; ANS2 = 1'bZ; ANS3 = 1'bZ;
                            end
                            2'b10: begin // pop
                                Pointer = (Pointer + 4) % 5;
                                ANS0 = cells[Pointer * 4 + 0];
                                ANS1 = cells[Pointer * 4 + 1];
                                ANS2 = cells[Pointer * 4 + 2];
                                ANS3 = cells[Pointer * 4 + 3];
                            end
                            2'b11: begin // get
                                adress = (Pointer + 9 - G) % 5;
                                ANS0 = cells[adress * 4 + 0];
                                ANS1 = cells[adress * 4 + 1];
                                ANS2 = cells[adress * 4 + 2];
                                ANS3 = cells[adress * 4 + 3];
                            end
                        endcase
                    end                
                endcase
            end
            1'b1: begin
                Pointer = 0;
                ANS0 = 1'bZ; ANS1 = 1'bZ; ANS2 = 1'bZ; ANS3 = 1'bZ;
                cells = 0;
            end
        endcase
    end
endmodule

module stack_behaviour_normal(
    input wire RESET, 
    input wire CLK, 
    input wire[1:0] COMMAND,
    input wire[2:0] INDEX,
    inout wire[3:0] IO_DATA
    ); 
    
    // put your code here, the other module (stack_behaviour_easy) must be deleted
    Stack stack(.OP0(COMMAND[0]), .OP1(COMMAND[1]), .RESET(RESET), .C(CLK), .G(INDEX), .D(IO_DATA), .ANS0(IO_DATA[0]), .ANS1(IO_DATA[1]), .ANS2(IO_DATA[2]), .ANS3(IO_DATA[3]));
    
endmodule
