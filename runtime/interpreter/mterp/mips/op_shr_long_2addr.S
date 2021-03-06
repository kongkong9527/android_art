    /*
     * Long integer shift, 2addr version.  vA is 64-bit value/result, vB is
     * 32-bit shift distance.
     */
    /* shr-long/2addr vA, vB */
    GET_OPA4(t2)                           #  t2 <- A+
    GET_OPB(a3)                            #  a3 <- B
    GET_VREG(a2, a3)                       #  a2 <- vB
    EAS2(t0, rFP, t2)                      #  t0 <- &fp[A]
    LOAD64(a0, a1, t0)                     #  a0/a1 <- vAA/vAA+1
    FETCH_ADVANCE_INST(1)                  #  advance rPC, load rINST
    GET_INST_OPCODE(t0)                    #  extract opcode from rINST

    andi    v0, a2, 0x20                   #  shift & 0x20
    sra     v1, a1, a2                     #  rhi<- ahi >> (shift&31)
    bnez    v0, .L${opcode}_finish
    srl     v0, a0, a2                     #  rlo<- alo >> (shift&31)
    not     a0, a2                         #  alo<- 31-shift (shift is 5b)
    sll     a1, 1
    sll     a1, a0                         #  ahi<- ahi << (32-(shift&31))
    or      v0, a1                         #  rlo<- rlo | ahi
    SET_VREG64_GOTO(v0, v1, t2, t0)        #  vAA/vAA+1 <- a0/a1
%break

.L${opcode}_finish:
    sra     a3, a1, 31                     #  a3<- sign(ah)
    SET_VREG64_GOTO(v1, a3, t2, t0)        #  vAA/vAA+1 <- rlo/rhi
