module ThreePusher (output wire Out0, Out1, Out2, input wire In0, In1, In2, B);
    and AND0(Out0, In0, B);
    and AND1(Out1, In1, B);
    and AND2(Out2, In2, B);
endmodule

module ThreeToFive (output wire S0, S1, S2, S3, S4, input wire A0, A1, A2);
    wire nA0, nA1, nA2;
    not negA0(nA0, A0);
    not negA1(nA1, A1);
    not negA2(nA2, A2);

    wire[7:0] ANS; // для каждого числ от 0 до 7 проверяем, не закодировано ли оно
    and ans0(ANS[0], nA0, nA1, nA2);
    and ans1(ANS[1], A0, nA1, nA2);
    and ans2(ANS[2], nA0, A1, nA2);
    and ans3(ANS[3], A0, A1, nA2);
    and ans4(ANS[4], nA0, nA1, A2);
    and ans5(ANS[5], A0, nA1, A2);
    and ans6(ANS[6], nA0, A1, A2);
    and ans7(ANS[7], A0, A1, A2);

    or OR0(S0, ANS[0], ANS[5]);
    or OR1(S1, ANS[1], ANS[6]);
    or OR2(S2, ANS[2], ANS[7]);
    or OR3(S3, ANS[3]);
    or OR4(S4, ANS[4]);
endmodule

module FiveToThree(output wire A0, A1, A2, input wire S0, S1, S2, S3, S4);
    or OR0(A0, S1, S3);
    or OR1(A1, S2, S3);
    or OR2(A2, S4);
endmodule

module DTrigger(output wire Q, input wire C, D);
    wire w1, w2, notQ, notD;
    not ND(notD, D);

    and IN1(w1, C, notD);
    and IN2(w2, C, D);
    nor NOR1(notQ, Q, w2);
    nor NOR2(Q, notQ, w1);
endmodule

module Comp10to1(output wire OUT, input wire B0, B1, B2, B3, B4, V0, V1, V2, V3, V4);
    wire[4:0] PUSH;
    and PV0(PUSH[0], B0, V0);
    and PV1(PUSH[1], B1, V1);
    and PV2(PUSH[2], B2, V2);
    and PV3(PUSH[3], B3, V3);
    and PV4(PUSH[4], B4, V4);
    or out(OUT, PUSH[0], PUSH[1], PUSH[2], PUSH[3], PUSH[4]);
endmodule

module StackCell(output wire Q0, Q1, Q2, Q3, input wire R, C, D0, D1, D2, D3);
    wire notR; not nr(notR, R);
    wire RorC; or r_or_c(RorC, R, C);
    wire D0andNR; and AND0(D0andNR, D0, notR);
    wire D1andNR; and AND1(D1andNR, D1, notR);
    wire D2andNR; and AND2(D2andNR, D2, notR);
    wire D3andNR; and AND3(D3andNR, D3, notR);
    DTrigger d_tr0(.C(RorC), .D(D0andNR), .Q(Q0));
    DTrigger d_tr1(.C(RorC), .D(D1andNR), .Q(Q1));
    DTrigger d_tr2(.C(RorC), .D(D2andNR), .Q(Q2));
    DTrigger d_tr3(.C(RorC), .D(D3andNR), .Q(Q3));
endmodule

module Demux(output wire C0, C1, C2, C3, C4, input wire A0, A1, A2, C);
    wire S0, S1, S2, S3, S4; 
    ThreeToFive ttf(.A0(A0), .A1(A1), .A2(A2), .S0(S0), .S1(S1), .S2(S2), .S3(S3), .S4(S4));
    and c0(C0, C, S0);
    and c1(C1, C, S1);
    and c2(C2, C, S2);
    and c3(C3, C, S3);
    and c4(C4, C, S4);
endmodule

module Plus1(output wire B0, B1, B2, input wire A0, A1, A2);
    wire S0, S1, S2, S3, S4;
    ThreeToFive ttf(.A0(A0), .A1(A1), .A2(A2), .S0(S0), .S1(S1), .S2(S2), .S3(S3), .S4(S4));
    FiveToThree fft(.S0(S4), .S1(S0), .S2(S1), .S3(S2), .S4(S3), .A0(B0), .A1(B1), .A2(B2));
endmodule

module Minus1(output wire B0, B1, B2, input wire A0, A1, A2);
    wire S0, S1, S2, S3, S4;
    ThreeToFive ttf(.A0(A0), .A1(A1), .A2(A2), .S0(S0), .S1(S1), .S2(S2), .S3(S3), .S4(S4));
    FiveToThree fft(.S0(S1), .S1(S2), .S2(S3), .S3(S4), .S4(S0), .A0(B0), .A1(B1), .A2(B2));
endmodule

module MUX(output wire Q0, Q1, Q2, Q3, input wire A0, A1, A2, D0, D1, D2, D3, D4, D5, D6, D7, D8, D9, D10, D11, D12, D13, D14, D15, D16, D17, D18, D19);
    wire S0, S1, S2, S3, S4;
    ThreeToFive mux_three_to_five(.A0(A0), .A1(A1), .A2(A2), .S0(S0), .S1(S1), .S2(S2), .S3(S3), .S4(S4));
    wire D0S0; and And_0_0(D0S0, D0, S0);
    wire D1S0; and And_1_0(D1S0, D1, S0);
    wire D2S0; and And_2_0(D2S0, D2, S0);
    wire D3S0; and And_3_0(D3S0, D3, S0);
    wire D4S1; and And_4_1(D4S1, D4, S1);
    wire D5S1; and And_5_1(D5S1, D5, S1);
    wire D6S1; and And_6_1(D6S1, D6, S1);
    wire D7S1; and And_7_1(D7S1, D7, S1);
    wire D8S2; and And_8_2(D8S2, D8, S2);
    wire D9S2; and And_9_2(D9S2, D9, S2);
    wire D10S2; and And_10_2(D10S2, D10, S2);
    wire D11S2; and And_11_2(D11S2, D11, S2);
    wire D12S3; and And_12_3(D12S3, D12, S3);
    wire D13S3; and And_13_3(D13S3, D13, S3);
    wire D14S3; and And_14_3(D14S3, D14, S3);
    wire D15S3; and And_15_3(D15S3, D15, S3);
    wire D16S4; and And_16_4(D16S4, D16, S4);
    wire D17S4; and And_17_4(D17S4, D17, S4);
    wire D18S4; and And_18_4(D18S4, D18, S4);
    wire D19S4; and And_19_4(D19S4, D19, S4);

    or OR0(Q0, D0S0, D4S1, D8S2, D12S3, D16S4);
    or OR1(Q1, D1S0, D5S1, D9S2, D13S3, D17S4);
    or OR2(Q2, D2S0, D6S1, D10S2, D14S3, D18S4);
    or OR3(Q3, D3S0, D7S1, D11S2, D15S3, D19S4);
endmodule

module MinusMod5(output wire R0, R1, R2, input wire A0, A1, A2, B0, B1, B2);
    wire X00, X01, X02; // A2A1A0 mod 5
    wire T0, T1, T2, T3, T4; // промежуточные провода для этого
    ThreeToFive ttf1(.A0(A0), .A1(A1), .A2(A2), .S0(T0), .S1(T1), .S2(T2), .S3(T3), .S4(T4));
    FiveToThree fft1(.A0(X00), .A1(X01), .A2(X02), .S0(T0), .S1(T1), .S2(T2), .S3(T3), .S4(T4));
    wire X10, X11, X12; // A2A1A0 - 1 mod 5
    wire X20, X21, X22; // A2A1A0 - 2 mod 5
    wire X30, X31, X32; // A2A1A0 - 3 mod 5
    wire X40, X41, X42; // A2A1A0 - 4 mod 5
    Minus1 m0(.A0(X00), .A1(X01), .A2(X02), .B0(X10), .B1(X11), .B2(X12));
    Minus1 m1(.A0(X10), .A1(X11), .A2(X12), .B0(X20), .B1(X21), .B2(X22));
    Minus1 m2(.A0(X20), .A1(X21), .A2(X22), .B0(X30), .B1(X31), .B2(X32));
    Minus1 m3(.A0(X30), .A1(X31), .A2(X32), .B0(X40), .B1(X41), .B2(X42));

    wire S0, S1, S2, S3, S4;
    ThreeToFive ttf2(.A0(B0), .A1(B1), .A2(B2), .S0(S0), .S1(S1), .S2(S2), .S3(S3), .S4(S4));

    Comp10to1 c0(.B0(S0), .B1(S1), .B2(S2), .B3(S3), .B4(S4), .V0(X00), .V1(X10), .V2(X20), .V3(X30), .V4(X40), .OUT(R0));
    Comp10to1 c1(.B0(S0), .B1(S1), .B2(S2), .B3(S3), .B4(S4), .V0(X01), .V1(X11), .V2(X21), .V3(X31), .V4(X41), .OUT(R1));
    Comp10to1 c2(.B0(S0), .B1(S1), .B2(S2), .B3(S3), .B4(S4), .V0(X02), .V1(X12), .V2(X22), .V3(X32), .V4(X42), .OUT(R2));
endmodule

module MEM(output wire Q0, Q1, Q2, Q3, input wire A0, A1, A2, R_W, C, RESET, D0, D1, D2, D3);
    wire C0, C1, C2, C3, C4;
    wire W0, W1, W2, W3, W4, W5, W6, W7, W8, W9, W10, W11, W12, W13, W14, W15, W16, W17, W18, W19;
    wire RWandC; and make_RWandC(RWandC, R_W, C);
    Demux dmx(.A0(A0), .A1(A1), .A2(A2), .C(RWandC), .C0(C0), .C1(C1), .C2(C2), .C3(C3), .C4(C4));
    StackCell cell0(.R(RESET), .C(C0), .D0(D0), .D1(D1), .D2(D2), .D3(D3), .Q0(W0), .Q1(W1), .Q2(W2), .Q3(W3));
    StackCell cell1(.R(RESET), .C(C1), .D0(D0), .D1(D1), .D2(D2), .D3(D3), .Q0(W4), .Q1(W5), .Q2(W6), .Q3(W7));
    StackCell cell2(.R(RESET), .C(C2), .D0(D0), .D1(D1), .D2(D2), .D3(D3), .Q0(W8), .Q1(W9), .Q2(W10), .Q3(W11));
    StackCell cell3(.R(RESET), .C(C3), .D0(D0), .D1(D1), .D2(D2), .D3(D3), .Q0(W12), .Q1(W13), .Q2(W14), .Q3(W15));
    StackCell cell4(.R(RESET), .C(C4), .D0(D0), .D1(D1), .D2(D2), .D3(D3), .Q0(W16), .Q1(W17), .Q2(W18), .Q3(W19));
    MUX mx(.A0(A0), .A1(A1), .A2(A2), .D0(W0), .D1(W1), .D2(W2), .D3(W3), .D4(W4), .D5(W5), .D6(W6), .D7(W7), .D8(W8), .D9(W9), .D10(W10), .D11(W11), .D12(W12), .D13(W13), .D14(W14), .D15(W15), .D16(W16), .D17(W17), .D18(W18), .D19(W19), .Q0(Q0), .Q1(Q1), .Q2(Q2), .Q3(Q3));
endmodule

module PointerModifier(output wire N0, N1, N2, input wire INF1, INF2, A0, A1, A2);
    wire notINF1; not ni1(notINF1, INF1);
    wire notINF2; not ni2(notINF2, INF2);
    wire PLUS, SAVE, MINUS;
    and plus_and(PLUS, notINF1,  INF2);
    and minus_and(MINUS, notINF2,  INF1);
    and save_and(SAVE, INF1,  INF2);
    wire P0, P1, P2; // указатель + 1
    Plus1 p1(.A0(A0), .A1(A1), .A2(A2), .B0(P0), .B1(P1), .B2(P2));
    wire M0, M1, M2; // указатель - 1
    Minus1 m1(.A0(A0), .A1(A1), .A2(A2), .B0(M0), .B1(M1), .B2(M2));
    wire AA0, AA1, AA2; ThreePusher save_pusher(.In0(A0), .In1(A1), .In2(A2), .B(SAVE), .Out0(AA0), .Out1(AA1), .Out2(AA2));
    wire MM0, MM1, MM2; ThreePusher save_minus(.In0(M0), .In1(M1), .In2(M2), .B(MINUS), .Out0(MM0), .Out1(MM1), .Out2(MM2));
    wire PP0, PP1, PP2; ThreePusher save_plus(.In0(P0), .In1(P1), .In2(P2), .B(PLUS), .Out0(PP0), .Out1(PP1), .Out2(PP2));
    or n0(N0, AA0, MM0, PP0);
    or n1(N1, AA1, MM1, PP1);
    or n2(N2, AA2, MM2, PP2);
endmodule

module OpToInf(output wire INF1, INF2, input wire OP0, OP1);
    wire xorOps; // OP0 ^ OP1
    xor make_xorOps(xorOps, OP0, OP1);
    wire not_xorOps; not make_not_xorOps(not_xorOps, xorOps); 
    or make_inf1(INF1, not_xorOps, OP1);
    or make_inf2(INF2, not_xorOps, OP0);
endmodule


module PointerManager(output wire[2:0] SAVED, NEW, input wire INF1, INF2, RESET, C);
    wire notRESET; not nR(notRESET, RESET);
    wire INF1andNOTRESET; and make_inf1andnR(INF1andNOTRESET, INF1, notRESET);
    wire INF2andNOTRESET; and make_inf2andnR(INF2andNOTRESET, INF2, notRESET);
    wire notC; not nC(notC, C);
    wire RESETorC; or make_RorC(RESETorC, RESET, C);
    wire RESETornC; or make_RornC(RESETornC, RESET, notC);

    wire[2:0] D;
    PointerModifier pmdf(.INF1(INF1andNOTRESET), .INF2(INF2andNOTRESET), .A0(SAVED[0]), .A1(SAVED[1]), .A2(SAVED[2]), .N0(D[0]), .N1(D[1]), .N2(D[2]));
    DTrigger dtr_n0(.C(RESETorC), .D(D[0]), .Q(NEW[0]));
    DTrigger dtr_n1(.C(RESETorC), .D(D[1]), .Q(NEW[1]));
    DTrigger dtr_n2(.C(RESETorC), .D(D[2]), .Q(NEW[2]));

    DTrigger dtr_s0(.C(RESETornC), .D(NEW[0]), .Q(SAVED[0]));
    DTrigger dtr_s1(.C(RESETornC), .D(NEW[1]), .Q(SAVED[1]));
    DTrigger dtr_s2(.C(RESETornC), .D(NEW[2]), .Q(SAVED[2]));
endmodule

module InAndOutHelper(output wire Q, input wire A, B);
    wire nA; not make_nA(nA, A);
    nmos p_tr(Q, (B), A);
    pmos n_tr(Q, (B), nA);
endmodule

module Stack(output wire ANS0, ANS1, ANS2, ANS3, input wire OP0, OP1, RESET, C, input wire[2:0] G, input wire[3:0] D);
    wire Q0, Q1, Q2, Q3;
    wire INF1, INF2;
    OpToInf oti(.OP0(OP0), .OP1(OP1), .INF1(INF1), .INF2(INF2));
    wire[2:0] SAVED;
    wire[2:0] NEW;
    PointerManager pm(.INF1(INF1), .INF2(INF2), .RESET(RESET), .C(C), .SAVED(SAVED), .NEW(NEW));
    
    wire nOP0; not not_op0(nOP0, OP0);
    wire nOP1; not not_op1(nOP1, OP1);
    
    wire NOP; and make_nop(NOP, nOP0, nOP1);
    wire PUSH; and make_push(PUSH, OP0, nOP1);
    wire POP; and make_pop(POP, nOP0, OP1);
    wire GET; and make_get(GET, OP0, OP1);
    wire GETorPOP; or make_get_ot_pop(GETorPOP, POP, GET);
    wire NEED_TO_READ; and make_need_to_read(NEED_TO_READ, GETorPOP, C);
    wire[2:0] PUSH_VALUES, POP_VALUES, GET_VALUES;
    // PUSH
    ThreePusher tp_push(.In0(SAVED[0]), .In1(SAVED[1]), .In2(SAVED[2]), .B(PUSH), .Out0(PUSH_VALUES[0]), .Out1(PUSH_VALUES[1]), .Out2(PUSH_VALUES[2]));
    // POP
    ThreePusher tp_pop(.In0(NEW[0]), .In1(NEW[1]), .In2(NEW[2]), .B(POP), .Out0(POP_VALUES[0]), .Out1(POP_VALUES[1]), .Out2(POP_VALUES[2]));
    // GET
    wire[2:0] G_PLUS1, G_MINUSED;
    Plus1 plus1_get(.A0(G[0]), .A1(G[1]), .A2(G[2]), .B0(G_PLUS1[0]), .B1(G_PLUS1[1]), .B2(G_PLUS1[2]));
    MinusMod5 minus_get(.A0(SAVED[0]), .A1(SAVED[1]), .A2(SAVED[2]), .B0(G_PLUS1[0]), .B1(G_PLUS1[1]), .B2(G_PLUS1[2]), .R0(G_MINUSED[0]), .R1(G_MINUSED[1]), .R2(G_MINUSED[2]));
    ThreePusher tp_get(.In0(G_MINUSED[0]), .In1(G_MINUSED[1]), .In2(G_MINUSED[2]), .B(GET), .Out0(GET_VALUES[0]), .Out1(GET_VALUES[1]), .Out2(GET_VALUES[2]));

    wire MEM_A0; or make_mem_a0(MEM_A0, PUSH_VALUES[0], POP_VALUES[0], GET_VALUES[0]);
    wire MEM_A1; or make_mem_a1(MEM_A1, PUSH_VALUES[1], POP_VALUES[1], GET_VALUES[1]);
    wire MEM_A2; or make_mem_a2(MEM_A2, PUSH_VALUES[2], POP_VALUES[2], GET_VALUES[2]);

    MEM stack_mem(.A0(MEM_A0), .A1(MEM_A1), .A2(MEM_A2), .R_W(PUSH), .C(C), .RESET(RESET), .D0(D[0]), .D1(D[1]), .D2(D[2]), .D3(D[3]), .Q0(Q0), .Q1(Q1), .Q2(Q2), .Q3(Q3));

    InAndOutHelper stack_ans0(.A(NEED_TO_READ), .B(Q0), .Q(ANS0));
    InAndOutHelper stack_ans1(.A(NEED_TO_READ), .B(Q1), .Q(ANS1));
    InAndOutHelper stack_ans2(.A(NEED_TO_READ), .B(Q2), .Q(ANS2));
    InAndOutHelper stack_ans3(.A(NEED_TO_READ), .B(Q3), .Q(ANS3));
endmodule

module stack_structural_normal(
    input wire RESET, 
    input wire CLK, 
    input wire[1:0] COMMAND,
    input wire[2:0] INDEX,
    inout wire[3:0] IO_DATA
    ); 
    
    // put your code here, the other module (stack_behaviour_easy) must be deleted
    Stack stack(.OP0(COMMAND[0]), .OP1(COMMAND[1]), .RESET(RESET), .C(CLK), .G(INDEX), .D(IO_DATA), .ANS0(IO_DATA[0]), .ANS1(IO_DATA[1]), .ANS2(IO_DATA[2]), .ANS3(IO_DATA[3]));
    
endmodule