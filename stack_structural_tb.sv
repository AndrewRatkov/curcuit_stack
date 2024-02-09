`include "stack_structural.sv"
bit print_hello = 0;

// tests_for modules
// 1 means that test will run
// 0 means that test will not run
bit test_main = 0;
bit need_to_test_DTrigger = 1 & (!test_main);
bit need_to_test_ThreeToFive = 1 & (!test_main);
bit need_to_test_FiveToThree = 1 & (!test_main);
bit need_to_test_StackCell = 1 & (!test_main);
bit need_to_test_ThreePusher = 1 & (!test_main);
bit need_to_test_Comp10to1 = 1 & (!test_main);
bit need_to_test_MUX = 1 & (!test_main);
bit need_to_test_DEMUX = 1 & (!test_main);
bit need_to_test_MEM = 1 & (!test_main);
bit need_to_debug_MEM = 0 & (!test_main);
bit need_to_test_Plus1 = 1 & (!test_main);
bit need_to_test_Minus1 = 1 & (!test_main);
bit need_to_test_MinusMod5 = 1 & (!test_main);
bit need_to_test_PointerManager = 1 & (!test_main);
bit need_to_test_PointerModifier = 1 & (!test_main);
bit need_to_test_OpToInf = 1 & (!test_main);
bit need_to_test_InAndOutHelper = 1 & (!test_main);
bit need_to_test_Stack = 1 & (!test_main);
bit need_to_debug_Stack = 0 & (!test_main);

module hello();
    initial begin
        if (print_hello)
            $display("Hello, I have some tests!");
    end
endmodule

module test_DTrigger();
    reg C, D; wire Q;
    DTrigger test_dtr(.C(C), .D(D), .Q(Q));
    int errors = 0;

    initial begin
        if (need_to_test_DTrigger) begin
            //$monitor("time: %0d: %b %b -> %b", $time, C, D, Q);
            C = 0; D = 0; // x на выходе
            #1;
            C = 1; D = 0;
            #1
            if (Q) errors++;
            C = 1; D = 1;
            #1
            if (!Q) errors++;
            C = 0; D = 1;
            #1
            if (!Q) errors++;
            C = 0; D = 0;
            #1
            if (!Q) errors++;
            C = 1; D = 0;
            #1
            if (Q) errors++;
            C = 1; D = 1;
            #1
            if (!Q) errors++;
            #200;
            if (errors) $display("D-trigger has some errors");
            else $display("No errors in D-trigger!");
        end
    end
endmodule

module test_ThreeToFive();
    int errors = 0;
    reg[2:0] A;
    wire[4:0] ANS;
    int I = 0;
    ThreeToFive test_ttf(.A0(A[0]), .A1(A[1]), .A2(A[2]), .S0(ANS[0]), .S1(ANS[1]), .S2(ANS[2]), .S3(ANS[3]), .S4(ANS[4]));
    initial begin
        if (need_to_test_ThreeToFive) begin
            for (A = 0; A < 7; A++) begin
                #1;
                for (I = 0; I < 5; I++) begin
                    if (I == A % 5 && (!ANS[I])) begin
                        $display("!!!");
                        errors++;
                    end
                    if (I != A % 5 && ANS[I]) begin
                        $display("!!!");
                        errors++;
                    end
                end
            end
            #200;
            if (errors)
                $display("%d errors happened in ThreeToFive", errors);
            else begin
                $display("No errors in ThreeToFive! [FULL CHECK]");
            end
        end
    end
endmodule

module test_FiveToThree();
    // ДА, МНЕ ЛЕНЬ ПИСАТЬ ПО-УМНОМУ!!!
    reg S0, S1, S2, S3, S4;
    wire A0, A1, A2;
    int errors = 0;
    FiveToThree test_ftt(.S0(S0), .S1(S1), .S2(S2), .S3(S3), .S4(S4), .A0(A0), .A1(A1), .A2(A2));
    initial begin
        if (need_to_test_FiveToThree) begin
            S0 = 1; S1 = 0; S2 = 0; S3 = 0; S4 = 0; #1;
            if (!((A0 == 0) & (A1 == 0) & (A2 == 0))) begin
                errors++;
            end

            S1 = 1; S0 = 0; #1;
            if (!((A0 == 1) & (A1 == 0) & (A2 == 0))) begin
                errors++;
            end

            S2 = 1; S1 = 0; #1;
            if (!((A0 == 0) & (A1 == 1) & (A2 == 0))) begin
                errors++;
            end

            S3 = 1; S2 = 0; #1;
            if (!((A0 == 1) & (A1 == 1) & (A2 == 0))) begin
                errors++;
            end

            S4 = 1; S3 = 0; #1;
            if (!((A0 == 0) & (A1 == 0) & (A2 == 1))) begin
                errors++;
            end
            #200;
            if (errors)
                $display("%d errors happened in FiveToThree", errors);
            else begin
                $display("No errors in FiveToThree! [FULL CHECK]");
            end
        end
    end

endmodule

module test_Three_pusher();
    reg[2:0] IN; reg B;
    wire[2:0] OUT;
    int errors = 0;
    ThreePusher test_three_pusher(.In0(IN[0]), .In1(IN[1]), .In2(IN[2]), .B(B), .Out0(OUT[0]), .Out1(OUT[1]), .Out2(OUT[2]));
    initial begin
        if (need_to_test_ThreePusher) begin
            B = 0;
            for (IN = 0; IN < 7; IN++) begin
                #1;
                if (OUT) errors++;
            end
            IN = 7; #1;
            if (OUT) errors++;
            B = 1;
            for (IN = 0; IN < 7; IN++) begin
                #1;
                if (OUT != IN) errors++;
            end
            IN = 7; #1;
            if (OUT != IN) errors++;
            #200;
            if (errors) $display("ThreePusher has some errors");
            else $display("No errors in ThreePusher! [FULL CHECK]");
        end
    end
endmodule

module test_Comp10to1();
    int errors = 0;
    reg BOOL0, BOOL1, BOOL2, BOOL3, BOOL4, VALUE0, VALUE1, VALUE2, VALUE3, VALUE4;
    wire OUT;
    Comp10to1 test_ctto(.B0(BOOL0), .B1(BOOL1), .B2(BOOL2), .B3(BOOL3), .B4(BOOL4), .V0(VALUE0), .V1(VALUE1), .V2(VALUE2), .V3(VALUE3), .V4(VALUE4), .OUT(OUT));
    initial begin
        if (need_to_test_Comp10to1) begin
            //$display("Checking");
            //$monitor("time: %0d: %b %b %b %b %b %b %b %b %b %b --> %b", $time, BOOL0, BOOL1, BOOL2, BOOL3, BOOL4, VALUE0, VALUE1, VALUE2, VALUE3, VALUE4, OUT);
            BOOL0 = 0; BOOL1 = 0; BOOL2 = 0; BOOL3 = 0; BOOL4 = 0; VALUE0 = 0; VALUE1 = 0; VALUE2 = 0; VALUE3 = 0; VALUE4 = 0;
            #1
            if (OUT) errors++; 
            BOOL0 = 1; VALUE0 = 1;
            #1
            if (!OUT) errors++;
            BOOL1 = 1; VALUE1 = 1; BOOL0 = 0;
            #1
            if (!OUT) errors++;
            BOOL2 = 1; BOOL1 = 0;
            #1
            if (OUT) errors++;
            BOOL3 = 1; BOOL2 = 0; VALUE3 = 1;
            #1
            if (!OUT) errors++;
            BOOL3 = 4; BOOL3 = 0; VALUE4 = 1;
            #1
            if (OUT) errors++;
            VALUE4 = 0;
            #1
            if (OUT) errors++;
            #200;
            if (errors) $display("Comp10to1 has some errors");
            else $display("No errors in Comp10to1!");
        end
    end
endmodule

module test_StackCell();
    reg R, C;
    reg [3:0] D;
    wire[3:0] Q;
    int errors = 0;

    StackCell test_sc(.R(R), .C(C), .D0(D[0]), .D1(D[1]), .D2(D[2]), .D3(D[3]), .Q0(Q[0]), .Q1(Q[1]), .Q2(Q[2]), .Q3(Q[3]));

    initial begin
        if (need_to_test_StackCell) begin
            //$monitor("time: %0d: %b %b %b %b %b %b -> %b %b %b %b", $time, R, C, D[0], D[1], D[2], D[3], Q[0], Q[1], Q[2], Q[3]);
            R = 0; C = 0; D = 0;
            #1 // должно быть x x x x
            D[0] = 1; D[3] = 1; #1; C = 1;
            #1 // пушули 1001
            if (Q != 9) errors++;
            R = 1; C = 0;
            #1 // обнулили всё
            if (Q != 0) errors++;
            R = 0;
            #1
            if (Q != 0) errors++;
            D[1] = 1; D[2] = 1; C = 1;
            #1 // пушнули 1111
            if (Q != 15) errors++;
            C = 0; #1;
            D[1] = 0; D[3] = 0; #1
            C = 1; // пушнули 1010
            if (Q != 15) errors++;
            #200;
            if (errors) $display("StackCell has some errors");
            else $display("No errors in StackCell!");
        end
    end
endmodule

module test_MUX();
    reg[2:0] A;
    reg[19:0] D;
    wire[3:0] Q;
    int errors = 0;
    MUX test_mux(.A0(A[0]), .A1(A[1]), .A2(A[2]), .D0(D[0]), .D1(D[1]), .D2(D[2]), .D3(D[3]), .D4(D[4]), .D5(D[5]), .D6(D[6]), .D7(D[7]), .D8(D[8]), .D9(D[9]), .D10(D[10]), .D11(D[11]), .D12(D[12]), .D13(D[13]), .D14(D[14]), .D15(D[15]), .D16(D[16]), .D17(D[17]), .D18(D[18]), .D19(D[19]), .Q0(Q[0]), .Q1(Q[1]), .Q2(Q[2]), .Q3(Q[3]));
    initial begin
        if (need_to_test_MUX) begin
            //$monitor("time: %0d: %b %b %b --> %b %b %b %b", $time, A[2], A[1], A[0], Q[0], Q[1], Q[2], Q[3]);
            D[0] = 0; D[1] = 1; D[2] = 1; D[3] = 0; 
            D[4] = 1; D[5] = 1; D[6] = 0; D[7] = 0; 
            D[8] = 0; D[9] = 0; D[10] = 1; D[11] = 1; 
            D[12] = 1; D[13] = 0; D[14] = 0; D[15] = 1; 
            D[16] = 1; D[17] = 0; D[18] = 1; D[19] = 1;
            for (A = 0; A < 7; A++) begin
                #1;
                if ((Q[0] != D[4 * (A % 5) + 0]) || (Q[1] != D[4 * (A % 5) + 1]) || (Q[2] != D[4 * (A % 5) + 2]) || (Q[3] != D[4 * (A % 5) + 3])) begin
                    $display("!!!");
                    errors++;
                end
            end
            A = 7; #1;
            if ((Q[0] != D[4 * (A % 5) + 0]) || (Q[1] != D[4 * (A % 5) + 1]) || (Q[2] != D[4 * (A % 5) + 2]) || (Q[3] != D[4 * (A % 5) + 3])) begin
                $display("!!!");
                errors++;
            end
            #200;
            if (errors)
                $display("%b errors happened in MUX", errors);
            else begin
                $display("No errors in MUX!");
            end

        end
   end

endmodule

module test_DEMUX();
    reg[2:0] A;
    int errors = 0;
    reg C;
    wire[4:0] ANS;
    int I;
    Demux test_dmx(.A0(A[0]), .A1(A[1]), .A2(A[2]), .C(C), .C0(ANS[0]), .C1(ANS[1]), .C2(ANS[2]), .C3(ANS[3]), .C4(ANS[4]));
    initial begin
        if (need_to_test_DEMUX) begin
            C = 0;
            for (A = 0; A < 7; ++A) begin
                #1;
                if (ANS != 0) begin
                    $display("!!!");
                    errors++;
                end
            end
            A = 7; #1;
            if (ANS != 0) begin
                $display("!!!");
                errors++;
            end
            C = 1;
            for (A = 0; A < 7; ++A) begin
                #1;
                for (I = 0; I < 5; I++) begin
                    if (I == A % 5) begin
                        if (!ANS[I]) begin
                            $display("!!!");
                            errors++;
                        end
                    end
                    else begin
                        if (ANS[I]) begin
                            $display("!!!");
                            errors++;
                        end
                    end
                end
            end
            #200;
            if (errors)
                $display("%b errors happened in DEMUX", errors);
            else begin
                $display("No errors in DEMUX! [FULL CHECK]");
            end
        end
    end

endmodule

module test_MEM();
    bit debug = need_to_debug_MEM;
    reg A0, A1, A2, R_W, C, RESET, D0, D1, D2, D3;
    wire[3:0] Q;
    MEM test_mem(.A0(A0), .A1(A1), .A2(A2), .R_W(R_W), .C(C), .RESET(RESET), .D0(D0), .D1(D1), .D2(D2), .D3(D3), .Q0(Q[0]), .Q1(Q[1]), .Q2(Q[2]), .Q3(Q[3]));
    int errors = 0;
    initial begin
        if (need_to_test_MEM) begin  
            if (debug) $monitor("time: %0d: A: %b %b %b R_W: %b C: %b RESET: %b D: %b %b %b %b --> %b %b %b %b", $time, A0, A1, A2, R_W, C, RESET, D0, D1, D2, D3, Q[0], Q[1], Q[2], Q[3]);
            if (debug) $display("Printing 1001 in 0 cell");
            RESET = 1; A2 = 0; A1 = 0; A0 = 0; R_W = 0; C = 0; #1;
            RESET = 0;
            A0 = 0; A1 = 0; A2 = 0; R_W = 0; C = 0; RESET = 0; D0 = 1; D1 = 0; D2 = 0; D3 = 1; // ничего никуда не записываем
            #1 R_W = 1; C = 1; // записываем в 0 ячейку 1001
            #1 C = 0; // возвратили синхронизацию 0
            #1 
            if (Q != 9) errors++;
            if (debug) $display("-----");
            if (debug) $display("Printing 1010 in 2 cell");
            A2 = 0; A1 = 1; A0 = 0; D0 = 1; D1 = 0; D2 = 1; D3 = 0; // хотим записать во вторую ячейку 1010
            #1 C = 1; // записываем
            #1 C = 0; // возвратили синхронизацию 0
            #1
            if ((!Q[0]) & Q[1] & (!Q[2]) & Q[3]) errors++;
            if (debug) $display("-----"); R_W = 0; A2 = 0; A1 = 0; A0 = 1; // читаем ячейку 1 (там ничего нет)
            if (debug) $display("Reading cell 1 (empty)");
            #1 C = 1; // читаем
            #1 C = 0; // обратно синхронизация 0
            #1;
            if (debug) $display("-----");
            if (debug) $display("Reading cell 0 (1001 expected)");
            D3 = 1; R_W = 0; A2 = 0; A1 = 0; A0 = 0; // читаем ячейку 0 (там 1001)
            #1 C = 1;
            #1 C = 0;
            #1
            if (Q != 9) errors++;
            if (debug) $display("-----");
            if (debug) $display("Printing 1111 in 2 cell");
            R_W = 1; A2 = 0; A1 = 1; A0 = 0; D0 = 1; D1 = 1; D2 = 1; D3 = 1; // хотим записать во вторую ячейку 1111
            #1 C = 1; // записываем
            #1 C = 0; // возвратили синхронизацию 0
            #1
            if (Q != 15) errors++;
            if (debug) $display("-----"); R_W = 0; A2 = 0; A1 = 1; A0 = 0; // читаем ячейку 1 (там ничего нет)
            if (debug) $display("Reading cell 2");
            #1 C = 1; // читаем
            #1 C = 0; // обратно синхронизация 0
            if (Q != 15) errors++;
            #200;
            if (errors)
                $display("%b errors happened in MEM", errors);
            else begin
                $display("No errors in MEM!");
            end
        end
    end
endmodule

module test_Plus1();
    reg[2:0] A; wire[2:0] B;
    int errors = 0;
    Plus1 test_plus1(.A0(A[0]), .A1(A[1]), .A2(A[2]), .B0(B[0]), .B1(B[1]), .B2(B[2]));
    initial begin
        if (need_to_test_Plus1) begin
            for (A = 0; A < 7; A++) begin
                #1;
                if (B != A + 1 && B != A - 4) begin
                    $display("%d %d", A, B);
                    errors++;
                end
            end
            A = 7; #1;
            if (B != 3) begin
                $display("!!!");
                errors++;
            end
            #200;
            if (errors)
                $display("%d errors happened in Plus1", errors);
            else begin
                $display("No errors in Plus1! [FULL CHECK]");
            end
        end
    end
endmodule

module test_Minus1();
    reg[2:0] A; wire[2:0] B;
    int errors = 0;
    Minus1 test_minus1(.A0(A[0]), .A1(A[1]), .A2(A[2]), .B0(B[0]), .B1(B[1]), .B2(B[2]));
    initial begin
        if (need_to_test_Minus1) begin
            for (A = 0; A < 7; A++) begin
                #1;
                if (B != A - 1 && B != A - 6 && B != A + 4) begin
                    $display("%d %d", A, B);
                    errors++;
                end
            end
            A = 7; #1;
            if (B != 1) begin
                $display("!!!");
                errors++;
            end
            #200;
            if (errors)
                $display("%d errors happened in Minus1", errors);
            else begin
                $display("No errors in Minus1! [FULL CHECK]");
            end
        end
    end
endmodule

module test_MinusMod5();
    reg[2:0] A;
    reg[2:0] B;
    wire[2:0] R;
    int errors = 0;
    MinusMod5 test_mm5(.A0(A[0]), .A1(A[1]), .A2(A[2]), .B0(B[0]), .B1(B[1]), .B2(B[2]), .R0(R[0]), .R1(R[1]), .R2(R[2]));
    initial begin
        if (need_to_test_MinusMod5) begin
            // $display("Checking Minus Mod 5");
            // the next string is useful for debug
            // $monitor("time: %0d: %b %b %b %b %b %b --> %b %b %b", $time, A[2], A[1], A[0], B[2], B[1], B[0], R[2], R[1], R[0]);
            for (A = 0; A < 7; A++) begin 
                for (B = 0; B < 7; B++) begin
                    #1;
                    if (R != A - B && R + 5 != A - B && R != A - B + 5 && R != A - B + 10) begin 
                        $display("!!!");
                        errors++;
                    end
                end
            end
            A = 7;
            for (B = 0; B < 7; B++) begin
                #1;
                if (R != A - B && R + 5 != A - B && R != A - B + 5 && R != A - B + 10) begin 
                    $display("!!!");
                    errors++;
                end
            end
            B = 7;
            for (A = 0; A < 7; A++) begin
                #1;
                if (R != A - B && R + 5 != A - B && R != A - B + 5 && R != A - B + 10) begin 
                    $display("!!!");
                    errors++;
                end
            end
            #200;
            if (errors)
                $display("%b errors happened in minusMod5", errors);
            else begin
                $display("No errors in minusMod5! [FULL CHECK]");
            end
        end
    end
endmodule : test_MinusMod5

module test_PointerModifier();
    reg INF1, INF2;
    reg[2:0] A; // inputs
    wire[2:0] N; // outputs
    int errors = 0;
    PointerModifier test_pm(.INF1(INF1), .INF2(INF2), .A0(A[0]), .A1(A[1]), .A2(A[2]), .N0(N[0]), .N1(N[1]), .N2(N[2]));
    initial begin
        if (need_to_test_PointerModifier) begin
            // SAVING
            INF1 = 1; INF2 = 1;
            for (A = 0; A < 7; A++) begin
                #1;
                if (N != A) begin
                    $display("!!!");
                    errors++;
                end
            end
            A = 7; #1;
            if (N != A) begin
                $display("!!!");
                errors++;
            end
            
            // PLUS
            INF1 = 0; INF2 = 1;
            for (A = 0; A < 7; A++) begin
                #1;
                if (N != A + 1 && N != A - 4) begin
                    $display("!!!");
                    errors++;
                end
            end
            A = 7; #1;
            if (N != A + 1 && N != A - 4) begin
                $display("!!!");
                errors++;
            end

            // MINUS
            INF1 = 1; INF2 = 0;
            for (A = 0; A < 7; A++) begin
                #1;
                if (N != A - 1 && N != A + 4 && N != A - 6) begin
                    $display("!!!");
                    errors++;
                end
            end
            A = 7; #1;
            if (N != A - 1 && N != A + 4 && N != A - 6) begin
                $display("!!!");
                errors++;
            end

            // NOP
            INF1 = 0; INF2 = 0;
            for (A = 0; A < 7; A++) begin
                #1;
                if (N != 0) begin
                    $display("!!!");
                    errors++;
                end
            end
            A = 7; #1;
            if (N != 0) begin
                $display("!!!");
                errors++;
            end
            #200;
            if (errors)
                $display("%b errors happened in Pointer Modifier", errors);
            else begin
                $display("No errors in Pointer Modifier! [FULL CHECK]");
            end
        end
    end
endmodule

module test_Pointer_Manager();
    reg INF1, INF2, RESET, C;
    wire[2:0] SAVED, NEW;
    int errors = 0;
    int i, new_expected, saved_expected;
    PointerManager test_pointer_m(.INF1(INF1), .INF2(INF2), .RESET(RESET), .C(C), .SAVED(SAVED), .NEW(NEW));
    initial begin
        if (need_to_test_PointerManager) begin
            //$monitor("time: %0d: %b %b %b %b --> saved: %b %b %b | new: %b %b %b", $time, INF1, INF2, RESET, C, SAVED[2], SAVED[1], SAVED[0], NEW[2], NEW[1], NEW[0]);
            RESET = 0; INF1 = 0; INF2 = 0; C = 0;
            #1; RESET = 1;
            #1; RESET = 0; INF2 = 1; #1; // будем много раз прибавлять 1
            if (!(NEW == 0 && SAVED == 0)) errors++;
            new_expected = 0; saved_expected = 0;
            for (i = 0; i < 8; i++) begin
                C = 1; #1;
                new_expected++;
                if (!(NEW == new_expected % 5 && SAVED == saved_expected % 5)) errors++;
                C = 0; #1;
                saved_expected++;
                if (!(NEW == new_expected % 5 && SAVED == saved_expected % 5)) errors++;
            end
            RESET = 1;
            #1; RESET = 0; INF2 = 0; INF1 = 1; #1; 
            if (!(NEW == 0 && SAVED == 0)) errors++;
            new_expected = 0; saved_expected = 0;
            for (i = 0; i < 8; i++) begin
                C = 1; #1;
                new_expected+=4;
                if (!(NEW == new_expected % 5 && SAVED == saved_expected % 5)) errors++;
                C = 0; #1;
                saved_expected+=4;
                if (!(NEW == new_expected % 5 && SAVED == saved_expected % 5)) errors++;
            end
            RESET = 1;
            #1; RESET = 0; INF2 = 1; #1; // будем много раз прибавлять 1 и потом сохраняться
            if (!(NEW == 0 && SAVED == 0)) errors++;
            new_expected = 0; saved_expected = 0;
            for (i = 0; i < 9; i++) begin
                INF1 = 0; #1;
                C = 1; #1;
                new_expected++;
                if (!(NEW == new_expected % 5 && SAVED == saved_expected % 5)) errors++;
                C = 0; #1;
                saved_expected++;
                if (!(NEW == new_expected % 5 && SAVED == saved_expected % 5)) errors++;
                INF1 = 1; #1;
                C = 1; #1;
                if (!(NEW == new_expected % 5 && SAVED == saved_expected % 5)) errors++;
                C = 0; #1;
                if (!(NEW == new_expected % 5 && SAVED == saved_expected % 5)) errors++;
            end
            RESET = 1;
            #1;
            if (!(NEW == 0 && SAVED == 0)) errors++;
            #200;
            if (errors)
                $display("%b errors happened in PointerManager", errors);
            else begin
                $display("No errors in PointerManager!");
            end
        end
    end
endmodule

module testOpToInf();
    reg OP0, OP1;
    wire INF1, INF2;
    int errors = 0;
    OpToInf test_op2inf(.OP0(OP0), .OP1(OP1), .INF1(INF1), .INF2(INF2));
    initial begin
        if (need_to_test_OpToInf) begin
            OP0 = 0; OP1 = 0; #1;
            if (!(INF1 == 1 & INF2 == 1)) begin
                errors++;
            end
            OP0 = 1; OP1 = 0; #1;
            if (!(INF1 == 0 & INF2 == 1)) begin
                errors++;
            end
            OP0 = 0; OP1 = 1; #1;
            if (!(INF1 == 1 & INF2 == 0)) begin
                errors++;
            end
            OP0 = 1; OP1 = 1; #1;
            if (!(INF1 == 1 & INF2 == 1)) begin
                errors++;
            end
            #200;
            if (errors)
                $display("%b errors happened in OpToInf", errors);
            else begin
                $display("No errors in OpToInf! [FULL CHECK]");
            end
        end
    end
endmodule

module test_InAndOutHelper();
    wire Q;
    wire Z; // is used like a constant z
    reg A, B;
    int errors = 0;
    InAndOutHelper test_ioh(.A(A), .B(B), .Q(Q));
    initial begin
        if (need_to_test_InAndOutHelper) begin
            A = 0; B = 0; #1;
            if (Q != Z) errors++;
            A = 0; B = 1; #1;
            if (Q != Z) errors++;
            A = 1; B = 0; #1;
            if (Q != 0) errors++;
            A = 1; B = 1; #1;
            if (Q != 1) errors++;
            #200;
            if (errors)
                $display("%b errors happened in InAndOutHelper", errors);
            else begin
                $display("No errors in InAndOutHelper! [FULL CHECK]");
            end
        end
    end
endmodule

module test_Stack();
    reg debug = need_to_debug_Stack;
    int errors = 0;

    reg OP0, OP1, RESET, C;
    reg[2:0] G;
    reg [3:0] D;

    wire ANS0, ANS1,  ANS2, ANS3; // ВЫХОДЫ
    wire Z;

    Stack test_stack(.OP0(OP0), .OP1(OP1), .RESET(RESET), .C(C), .G(G), .D(D), .ANS0(ANS0), .ANS1(ANS1), .ANS2(ANS2), .ANS3(ANS3));

    initial begin
        if (need_to_test_Stack) begin
//            $monitor("time: %0d: OP: %b %b;  RESET: %b C: %b NEW: %b SAVED: %b", $time, OP0, OP1, RESET, C, NEW, SAVED);
            OP0 = 1; OP1 = 1; C = 0; RESET = 1; D = 4; G = 0; #1;
            RESET = 0; #1;
            C = 1; #1;
//            $display("=== %b %b %b %b", ANS0, ANS1, ANS2, ANS3);
            C = 0; #1;
            OP0 = 1; OP1 = 0; #1;
            C = 1; #1;
            if (debug)
                $display("PUSHED %b %b %b %b", D[3], D[2], D[1], D[0]);
            errors += (ANS0 != Z || ANS1 != Z || ANS2 != Z || ANS3 != Z); // выходы все Z!!!
            C = 0; #1;
            D = 15; #1;
            C = 1; #1;
            if (debug)
                $display("PUSHED %b %b %b %b", D[3], D[2], D[1], D[0]);
            errors += (ANS0 != Z || ANS1 != Z || ANS2 != Z || ANS3 != Z); // выходы все Z!!!
            C = 0; #1;
            D = 2; #1;
            C = 1; #1;
            if (debug)
                $display("PUSHED %b %b %b %b", D[3], D[2], D[1], D[0]);
            errors += (ANS0 != Z || ANS1 != Z || ANS2 != Z || ANS3 != Z); // выходы все Z!!!
            C = 0; #1;
            OP0 = 1; OP1 = 1;
            if (debug)
                $display("GET RESULTS");
            for (G = 0; G < 7; G++) begin
                #1;
                C = 1; #1;
                if (debug)
                    $display("%d: %b %b %b %b", G, ANS3, ANS2, ANS1, ANS0);
                C = 0; #1;
            end
            OP0 = 0; OP1 = 1; #1;
            C = 1; #1;
            if (debug)
                $display("POPPED %b %b %b %b", ANS3, ANS2, ANS1, ANS0);
            C = 0; #1;
            OP0 = 1; OP1 = 0; D = 7; #1;
            C = 1; #1;
            if (debug)
                $display("PUSHED %b %b %b %b", D[3], D[2], D[1], D[0]);
            errors += (ANS0 != Z || ANS1 != Z || ANS2 != Z || ANS3 != Z); // выходы все Z!!!
            C = 0; #1;
            OP0 = 1; OP1 = 1;
            if (debug)
                $display("GET RESULTS");
            for (G = 0; G < 7; G++) begin
                #1;
                C = 1; #1;
                if (debug)
                    $display("%d: %b %b %b %b", G, ANS3, ANS2, ANS1, ANS0);
                C = 0; #1;
            end
            OP0 = 1; OP1 = 0; D = 1; #1;
            C = 1; #1;
            errors += (ANS0 != Z || ANS1 != Z || ANS2 != Z || ANS3 != Z); // выходы все Z!!!
            if (debug)
                $display("PUSHED %b %b %b %b", D[3], D[2], D[1], D[0]);
            C = 0; #1;
            OP0 = 1; OP1 = 0; D = 10; #1;
            C = 1; #1;
            errors += (ANS0 != Z || ANS1 != Z || ANS2 != Z || ANS3 != Z); // выходы все Z!!!
            if (debug)
                $display("PUSHED %b %b %b %b", D[3], D[2], D[1], D[0]);
            C = 0; #1;
            OP0 = 1; OP1 = 1;
            if (debug)
                $display("GET RESULTS");
            for (G = 0; G < 7; G++) begin
                #1;
                C = 1; #1;
                if (debug)
                    $display("%d: %b %b %b %b", G, ANS3, ANS2, ANS1, ANS0);
                C = 0; #1;
            end
            OP0 = 1; OP1 = 0; D = 11; #1;
            C = 1; #1;
            errors += (ANS0 != Z || ANS1 != Z || ANS2 != Z || ANS3 != Z); // выходы все Z!!!
            if (debug)
                $display("PUSHED %b %b %b %b", D[3], D[2], D[1], D[0]);
            C = 0; #1;
            OP0 = 1; OP1 = 1;
            if (debug)
                $display("GET RESULTS");
            for (G = 0; G < 7; G++) begin
                #1;
                C = 1; #1;
                if (debug)
                    $display("%d: %b %b %b %b", G, ANS3, ANS2, ANS1, ANS0);
                C = 0; #1;
            end
            D[0] = Z; D[1] = Z; D[2] = Z; D[3] = Z;
            for (G = 0; G < 7; G++) begin
                #1;
                C = 1; #1;
                if (debug)
                    $display("%d: %b %b %b %b", G, ANS3, ANS2, ANS1, ANS0);
                C = 0; #1;
            end
            #200;
            if (errors)
                $display("%b errors happened in Stack", errors);
            else begin
                $display("No errors in Stack!");
            end
        end
    end
endmodule



module stack_structural_tb;
    reg debug = 0;
    int errors = 0;

    wire[3:0] IO_DATA;
    reg RESET;
    reg CLK;
    reg[1:0] COMMAND;
    reg[2:0] INDEX;

    // ввод данных утроен так: мы просто пишем, что хотим положить, в IO_DATA2
    // если мы собираемся сделать pop/get, в IO_DATA2 надо присвоить 4'bZZZZ
    reg[3:0] IO_DATA2;
    assign IO_DATA = IO_DATA2;

    stack_structural_normal stack(.IO_DATA(IO_DATA), .RESET(RESET), .CLK(CLK), .COMMAND(COMMAND), .INDEX(INDEX));

    initial begin
        if (test_main) begin
            // когда хотим делать pop/get, в IO_DATA2 надо присвоить 4'bZZZZ

            $display("DEBUG MAIN");
            // для начала давайте просто сделаем RESET
            $display("1)Делаем RESET");
            COMMAND = 1; CLK = 0; RESET = 1; IO_DATA2 = 4'bZZZZ; INDEX = 0; #1;
            RESET = 0; #1;
            $display("Проверим, что везде лежат нули:");
            // проверим, что везде лежат нули
            COMMAND = 3; #1;
            for (INDEX = 0; INDEX < 7; INDEX++) begin
                #1;
                CLK = 1; #1;
                $display("get %d: %b (%d)", INDEX, IO_DATA, IO_DATA);
                CLK = 0; #1;
            end
            INDEX = 7; #1;
            CLK = 1; #1;
            $display("get %d: %b (%d)", INDEX, IO_DATA, IO_DATA);
            CLK = 0; #1;

            $display("2)Давайте теперь запушаем что-то: (4; 15; 2)");
            COMMAND = 1; IO_DATA2 = 4; #1;
            CLK = 1; #1;
            $display("PUSHED %b (%d)", IO_DATA, IO_DATA);
            CLK = 0; #1;

            IO_DATA2 = 15; #1;
            CLK = 1; #1;
            $display("PUSHED %b (%d)", IO_DATA, IO_DATA);
            CLK = 0; #1;
            
            IO_DATA2 = 2; #1;
            CLK = 1; #1;
            $display("PUSHED %b (%d)", IO_DATA, IO_DATA);
            CLK = 0; #1;
            
            COMMAND = 3; IO_DATA2 = 4'bZZZZ; #1;
            $display("И снова проверим, что у нас там лежит в стеке:");
            for (INDEX = 0; INDEX < 7; INDEX++) begin
                #1;
                CLK = 1; #1;
                $display("get %d: %b (%d)", INDEX, IO_DATA, IO_DATA);
                CLK = 0; #1;
            end
            INDEX = 7; #1;
            CLK = 1; #1;
            $display("get %d: %b (%d)", INDEX, IO_DATA, IO_DATA);
            CLK = 0; #1;

            $display("3)Сделаем два раза pop");
            COMMAND = 2; #1;
            CLK = 1; #1;
            $display("POPPED %b (%d)", IO_DATA, IO_DATA);
            CLK = 0; #1;
            CLK = 1; #1;
            $display("POPPED %b (%d)", IO_DATA, IO_DATA);
            CLK = 0; #1;

            COMMAND = 3; IO_DATA2 = 4'bZZZZ; #1;
            $display("И снова проверим, что у нас там лежит в стеке:");
            for (INDEX = 0; INDEX < 7; INDEX++) begin
                #1;
                CLK = 1; #1;
                $display("get %d: %b (%d)", INDEX, IO_DATA, IO_DATA);
                CLK = 0; #1;
            end
            INDEX = 7; #1;
            CLK = 1; #1;
            $display("get %d: %b (%d)", INDEX, IO_DATA, IO_DATA);
            CLK = 0; #1;

            $display("4)Давайте снова запушаем что-то: (10, 3, 9, 8)");
            COMMAND = 1; IO_DATA2 = 10; #1;
            CLK = 1; #1;
            $display("PUSHED %b (%d)", IO_DATA, IO_DATA);
            CLK = 0; #1;

            IO_DATA2 = 3; #1;
            CLK = 1; #1;
            $display("PUSHED %b (%d)", IO_DATA, IO_DATA);
            CLK = 0; #1;
            
            IO_DATA2 = 9; #1;
            CLK = 1; #1;
            $display("PUSHED %b (%d)", IO_DATA, IO_DATA);
            CLK = 0; #1;

            IO_DATA2 = 8; #1;
            CLK = 1; #1;
            $display("PUSHED %b (%d)", IO_DATA, IO_DATA);
            CLK = 0; #1;
            
            COMMAND = 3; IO_DATA2 = 4'bZZZZ; #1;
            $display("И снова проверим, что у нас там лежит в стеке:");
            for (INDEX = 0; INDEX < 7; INDEX++) begin
                #1;
                CLK = 1; #1;
                $display("get %d: %b (%d)", INDEX, IO_DATA, IO_DATA);
                CLK = 0; #1;
            end
            INDEX = 7; #1;
            CLK = 1; #1;
            $display("get %d: %b (%d)", INDEX, IO_DATA, IO_DATA);
            CLK = 0; #1;

            $display("5)И ещё раз запушаем что-то, чтобы случился переход по циклу и перезапись: (1, 0, 5)");
            COMMAND = 1; IO_DATA2 = 1; #1;
            CLK = 1; #1;
            $display("PUSHED %b (%d)", IO_DATA, IO_DATA);
            CLK = 0; #1;

            IO_DATA2 = 0; #1;
            CLK = 1; #1;
            $display("PUSHED %b (%d)", IO_DATA, IO_DATA);
            CLK = 0; #1;
            
            IO_DATA2 = 5; #1;
            CLK = 1; #1;
            $display("PUSHED %b (%d)", IO_DATA, IO_DATA);
            CLK = 0; #1;

            COMMAND = 3; IO_DATA2 = 4'bZZZZ; #1;
            $display("И снова проверим, что у нас там лежит в стеке:");
            for (INDEX = 0; INDEX < 7; INDEX++) begin
                #1;
                CLK = 1; #1;
                $display("get %d: %b (%d)", INDEX, IO_DATA, IO_DATA);
                CLK = 0; #1;
            end
            INDEX = 7; #1;
            CLK = 1; #1;
            $display("get %d: %b (%d)", INDEX, IO_DATA, IO_DATA);
            CLK = 0; #1;

            $display("6)Снова делаем RESET");
            COMMAND = 1; CLK = 0; RESET = 1; IO_DATA2 = 4'bZZZZ; INDEX = 0; #1;
            RESET = 0; #1;
            $display("Проверим, что везде лежат нули:");
            // проверим, что везде лежат нули
            COMMAND = 3; #1;
            for (INDEX = 0; INDEX < 7; INDEX++) begin
                #1;
                CLK = 1; #1;
                $display("get %d: %b (%d)", INDEX, IO_DATA, IO_DATA);
                CLK = 0; #1;
            end
            INDEX = 7; #1;
            CLK = 1; #1;
            $display("get %d: %b (%d)", INDEX, IO_DATA, IO_DATA);
            CLK = 0; #1;

            $display("7)Попробуем сделать pop");
            COMMAND = 2; #1;
            CLK = 1; #1;
            $display("POPPED %b (%d)", IO_DATA, IO_DATA);
            CLK = 0; #1;

            COMMAND = 3; IO_DATA2 = 4'bZZZZ; #1;
            $display("И снова проверим, что у нас там лежит в стеке:");
            for (INDEX = 0; INDEX < 7; INDEX++) begin
                #1;
                CLK = 1; #1;
                $display("get %d: %b (%d)", INDEX, IO_DATA, IO_DATA);
                CLK = 0; #1;
            end
            INDEX = 7; #1;
            CLK = 1; #1;
            $display("get %d: %b (%d)", INDEX, IO_DATA, IO_DATA);
            CLK = 0; #1;

            $display("8)Давайте снова запушаем что-то: (4)");
            COMMAND = 1; IO_DATA2 = 4; #1;
            CLK = 1; #1;
            $display("PUSHED %b (%d)", IO_DATA, IO_DATA);
            CLK = 0; #1;

            COMMAND = 3; IO_DATA2 = 4'bZZZZ; #1;
            $display("И снова проверим, что у нас там лежит в стеке:");
            for (INDEX = 0; INDEX < 7; INDEX++) begin
                #1;
                CLK = 1; #1;
                $display("get %d: %b (%d)", INDEX, IO_DATA, IO_DATA);
                CLK = 0; #1;
            end
            INDEX = 7; #1;
            CLK = 1; #1;
            $display("get %d: %b (%d)", INDEX, IO_DATA, IO_DATA);
            CLK = 0; #1;


        end
    end

    
endmodule