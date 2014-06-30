(* Capstone Disassembler Engine
 * By Guillaume Jeanne <guillaume.jeanne@ensimag.fr>, 2014> *)


type ppc_op_mem = {
	base: int;
	disp: int;
}

type ppc_op = 
	| PPC_OP_INVALID of int
	| PPC_OP_REG of int
	| PPC_OP_IMM of int
	| PPC_OP_MEM of ppc_op_mem

type cs_ppc = { 
	bc: int;
	bh: int;
	update_cr0: bool;
	op_count: int;
	operands: ppc_op array;
}


(*  PPC branch codes for some branch instructions *)
let _PPC_BC_LT = (0<<5)|12;;
let _PPC_BC_LE = (1<<5)|4;;
let _PPC_BC_EQ = (2<<5)|12;;
let _PPC_BC_GE = (0<<5)|4;;
let _PPC_BC_GT = (1<<5)|12;;
let _PPC_BC_NE = (2<<5)|4;;
let _PPC_BC_UN = (3<<5)|12;;
let _PPC_BC_NU = (3<<5)|4;;
let _PPC_BC_LT_MINUS = (0<<5)|14;;
let _PPC_BC_LE_MINUS = (1<<5)|6;;
let _PPC_BC_EQ_MINUS = (2<<5)|14;;
let _PPC_BC_GE_MINUS = (0<<5)|6;;
let _PPC_BC_GT_MINUS = (1<<5)|14;;
let _PPC_BC_NE_MINUS = (2<<5)|6;;
let _PPC_BC_UN_MINUS = (3<<5)|14;;
let _PPC_BC_NU_MINUS = (3<<5)|6;;
let _PPC_BC_LT_PLUS = (0<<5)|15;;
let _PPC_BC_LE_PLUS = (1<<5)|7;;
let _PPC_BC_EQ_PLUS = (2<<5)|15;;
let _PPC_BC_GE_PLUS = (0<<5)|7;;
let _PPC_BC_GT_PLUS = (1<<5)|15;;
let _PPC_BC_NE_PLUS = (2<<5)|7;;
let _PPC_BC_UN_PLUS = (3<<5)|15;;
let _PPC_BC_NU_PLUS = (3<<5)|7;;

(*  PPC branch hint for some branch instructions *)

let _PPC_BH_NO = 0;;
let _PPC_BH_PLUS = 1;;
let _PPC_BH_MINUS = 2;;

(*  Operand type for instruction's operands *)

let _PPC_OP_INVALID = 0;;
let _PPC_OP_REG = 1;;
let _PPC_OP_IMM = 2;;
let _PPC_OP_MEM = 3;;

(*  PPC registers *)

let _PPC_REG_INVALID = 0;;
let _PPC_REG_CARRY = 1;;
let _PPC_REG_CR0 = 2;;
let _PPC_REG_CR1 = 3;;
let _PPC_REG_CR2 = 4;;
let _PPC_REG_CR3 = 5;;
let _PPC_REG_CR4 = 6;;
let _PPC_REG_CR5 = 7;;
let _PPC_REG_CR6 = 8;;
let _PPC_REG_CR7 = 9;;
let _PPC_REG_CR8 = 10;;
let _PPC_REG_CR9 = 11;;
let _PPC_REG_CR10 = 12;;
let _PPC_REG_CR11 = 13;;
let _PPC_REG_CR12 = 14;;
let _PPC_REG_CR13 = 15;;
let _PPC_REG_CR14 = 16;;
let _PPC_REG_CR15 = 17;;
let _PPC_REG_CR16 = 18;;
let _PPC_REG_CR17 = 19;;
let _PPC_REG_CR18 = 20;;
let _PPC_REG_CR19 = 21;;
let _PPC_REG_CR20 = 22;;
let _PPC_REG_CR21 = 23;;
let _PPC_REG_CR22 = 24;;
let _PPC_REG_CR23 = 25;;
let _PPC_REG_CR24 = 26;;
let _PPC_REG_CR25 = 27;;
let _PPC_REG_CR26 = 28;;
let _PPC_REG_CR27 = 29;;
let _PPC_REG_CR28 = 30;;
let _PPC_REG_CR29 = 31;;
let _PPC_REG_CR30 = 32;;
let _PPC_REG_CR31 = 33;;
let _PPC_REG_CTR = 34;;
let _PPC_REG_F0 = 35;;
let _PPC_REG_F1 = 36;;
let _PPC_REG_F2 = 37;;
let _PPC_REG_F3 = 38;;
let _PPC_REG_F4 = 39;;
let _PPC_REG_F5 = 40;;
let _PPC_REG_F6 = 41;;
let _PPC_REG_F7 = 42;;
let _PPC_REG_F8 = 43;;
let _PPC_REG_F9 = 44;;
let _PPC_REG_F10 = 45;;
let _PPC_REG_F11 = 46;;
let _PPC_REG_F12 = 47;;
let _PPC_REG_F13 = 48;;
let _PPC_REG_F14 = 49;;
let _PPC_REG_F15 = 50;;
let _PPC_REG_F16 = 51;;
let _PPC_REG_F17 = 52;;
let _PPC_REG_F18 = 53;;
let _PPC_REG_F19 = 54;;
let _PPC_REG_F20 = 55;;
let _PPC_REG_F21 = 56;;
let _PPC_REG_F22 = 57;;
let _PPC_REG_F23 = 58;;
let _PPC_REG_F24 = 59;;
let _PPC_REG_F25 = 60;;
let _PPC_REG_F26 = 61;;
let _PPC_REG_F27 = 62;;
let _PPC_REG_F28 = 63;;
let _PPC_REG_F29 = 64;;
let _PPC_REG_F30 = 65;;
let _PPC_REG_F31 = 66;;
let _PPC_REG_LR = 67;;
let _PPC_REG_R0 = 68;;
let _PPC_REG_R1 = 69;;
let _PPC_REG_R2 = 70;;
let _PPC_REG_R3 = 71;;
let _PPC_REG_R4 = 72;;
let _PPC_REG_R5 = 73;;
let _PPC_REG_R6 = 74;;
let _PPC_REG_R7 = 75;;
let _PPC_REG_R8 = 76;;
let _PPC_REG_R9 = 77;;
let _PPC_REG_R10 = 78;;
let _PPC_REG_R11 = 79;;
let _PPC_REG_R12 = 80;;
let _PPC_REG_R13 = 81;;
let _PPC_REG_R14 = 82;;
let _PPC_REG_R15 = 83;;
let _PPC_REG_R16 = 84;;
let _PPC_REG_R17 = 85;;
let _PPC_REG_R18 = 86;;
let _PPC_REG_R19 = 87;;
let _PPC_REG_R20 = 88;;
let _PPC_REG_R21 = 89;;
let _PPC_REG_R22 = 90;;
let _PPC_REG_R23 = 91;;
let _PPC_REG_R24 = 92;;
let _PPC_REG_R25 = 93;;
let _PPC_REG_R26 = 94;;
let _PPC_REG_R27 = 95;;
let _PPC_REG_R28 = 96;;
let _PPC_REG_R29 = 97;;
let _PPC_REG_R30 = 98;;
let _PPC_REG_R31 = 99;;
let _PPC_REG_V0 = 100;;
let _PPC_REG_V1 = 101;;
let _PPC_REG_V2 = 102;;
let _PPC_REG_V3 = 103;;
let _PPC_REG_V4 = 104;;
let _PPC_REG_V5 = 105;;
let _PPC_REG_V6 = 106;;
let _PPC_REG_V7 = 107;;
let _PPC_REG_V8 = 108;;
let _PPC_REG_V9 = 109;;
let _PPC_REG_V10 = 110;;
let _PPC_REG_V11 = 111;;
let _PPC_REG_V12 = 112;;
let _PPC_REG_V13 = 113;;
let _PPC_REG_V14 = 114;;
let _PPC_REG_V15 = 115;;
let _PPC_REG_V16 = 116;;
let _PPC_REG_V17 = 117;;
let _PPC_REG_V18 = 118;;
let _PPC_REG_V19 = 119;;
let _PPC_REG_V20 = 120;;
let _PPC_REG_V21 = 121;;
let _PPC_REG_V22 = 122;;
let _PPC_REG_V23 = 123;;
let _PPC_REG_V24 = 124;;
let _PPC_REG_V25 = 125;;
let _PPC_REG_V26 = 126;;
let _PPC_REG_V27 = 127;;
let _PPC_REG_V28 = 128;;
let _PPC_REG_V29 = 129;;
let _PPC_REG_V30 = 130;;
let _PPC_REG_V31 = 131;;
let _PPC_REG_VRSAVE = 132;;
let _PPC_REG_RM = 133;;
let _PPC_REG_CTR8 = 134;;
let _PPC_REG_LR8 = 135;;
let _PPC_REG_CR1EQ = 136;;
let _PPC_REG_MAX = 137;;

(*  PPC instruction *)

let _PPC_INS_INVALID = 0;;
let _PPC_INS_ADD = 1;;
let _PPC_INS_ADDC = 2;;
let _PPC_INS_ADDE = 3;;
let _PPC_INS_ADDI = 4;;
let _PPC_INS_ADDIC = 5;;
let _PPC_INS_ADDIS = 6;;
let _PPC_INS_ADDME = 7;;
let _PPC_INS_ADDZE = 8;;
let _PPC_INS_AND = 9;;
let _PPC_INS_ANDC = 10;;
let _PPC_INS_ANDIS = 11;;
let _PPC_INS_ANDI = 12;;
let _PPC_INS_B = 13;;
let _PPC_INS_BA = 14;;
let _PPC_INS_BCL = 15;;
let _PPC_INS_BCTR = 16;;
let _PPC_INS_BCTRL = 17;;
let _PPC_INS_BDNZ = 18;;
let _PPC_INS_BDNZA = 19;;
let _PPC_INS_BDNZL = 20;;
let _PPC_INS_BDNZLA = 21;;
let _PPC_INS_BDNZLR = 22;;
let _PPC_INS_BDNZLRL = 23;;
let _PPC_INS_BDZ = 24;;
let _PPC_INS_BDZA = 25;;
let _PPC_INS_BDZL = 26;;
let _PPC_INS_BDZLA = 27;;
let _PPC_INS_BDZLR = 28;;
let _PPC_INS_BDZLRL = 29;;
let _PPC_INS_BL = 30;;
let _PPC_INS_BLA = 31;;
let _PPC_INS_BLR = 32;;
let _PPC_INS_BLRL = 33;;
let _PPC_INS_CMPD = 34;;
let _PPC_INS_CMPDI = 35;;
let _PPC_INS_CMPLD = 36;;
let _PPC_INS_CMPLDI = 37;;
let _PPC_INS_CMPLW = 38;;
let _PPC_INS_CMPLWI = 39;;
let _PPC_INS_CMPW = 40;;
let _PPC_INS_CMPWI = 41;;
let _PPC_INS_CNTLZD = 42;;
let _PPC_INS_CNTLZW = 43;;
let _PPC_INS_CREQV = 44;;
let _PPC_INS_CRXOR = 45;;
let _PPC_INS_CRAND = 46;;
let _PPC_INS_CRANDC = 47;;
let _PPC_INS_CRNAND = 48;;
let _PPC_INS_CRNOR = 49;;
let _PPC_INS_CROR = 50;;
let _PPC_INS_CRORC = 51;;
let _PPC_INS_DCBA = 52;;
let _PPC_INS_DCBF = 53;;
let _PPC_INS_DCBI = 54;;
let _PPC_INS_DCBST = 55;;
let _PPC_INS_DCBT = 56;;
let _PPC_INS_DCBTST = 57;;
let _PPC_INS_DCBZ = 58;;
let _PPC_INS_DCBZL = 59;;
let _PPC_INS_DIVD = 60;;
let _PPC_INS_DIVDU = 61;;
let _PPC_INS_DIVW = 62;;
let _PPC_INS_DIVWU = 63;;
let _PPC_INS_DSS = 64;;
let _PPC_INS_DSSALL = 65;;
let _PPC_INS_DST = 66;;
let _PPC_INS_DSTST = 67;;
let _PPC_INS_DSTSTT = 68;;
let _PPC_INS_DSTT = 69;;
let _PPC_INS_EIEIO = 70;;
let _PPC_INS_EQV = 71;;
let _PPC_INS_EXTSB = 72;;
let _PPC_INS_EXTSH = 73;;
let _PPC_INS_EXTSW = 74;;
let _PPC_INS_FABS = 75;;
let _PPC_INS_FADD = 76;;
let _PPC_INS_FADDS = 77;;
let _PPC_INS_FCFID = 78;;
let _PPC_INS_FCFIDS = 79;;
let _PPC_INS_FCFIDU = 80;;
let _PPC_INS_FCFIDUS = 81;;
let _PPC_INS_FCMPU = 82;;
let _PPC_INS_FCPSGN = 83;;
let _PPC_INS_FCTID = 84;;
let _PPC_INS_FCTIDUZ = 85;;
let _PPC_INS_FCTIDZ = 86;;
let _PPC_INS_FCTIW = 87;;
let _PPC_INS_FCTIWUZ = 88;;
let _PPC_INS_FCTIWZ = 89;;
let _PPC_INS_FDIV = 90;;
let _PPC_INS_FDIVS = 91;;
let _PPC_INS_FMADD = 92;;
let _PPC_INS_FMADDS = 93;;
let _PPC_INS_FMR = 94;;
let _PPC_INS_FMSUB = 95;;
let _PPC_INS_FMSUBS = 96;;
let _PPC_INS_FMUL = 97;;
let _PPC_INS_FMULS = 98;;
let _PPC_INS_FNABS = 99;;
let _PPC_INS_FNEG = 100;;
let _PPC_INS_FNMADD = 101;;
let _PPC_INS_FNMADDS = 102;;
let _PPC_INS_FNMSUB = 103;;
let _PPC_INS_FNMSUBS = 104;;
let _PPC_INS_FRE = 105;;
let _PPC_INS_FRES = 106;;
let _PPC_INS_FRIM = 107;;
let _PPC_INS_FRIN = 108;;
let _PPC_INS_FRIP = 109;;
let _PPC_INS_FRIZ = 110;;
let _PPC_INS_FRSP = 111;;
let _PPC_INS_FRSQRTE = 112;;
let _PPC_INS_FRSQRTES = 113;;
let _PPC_INS_FSEL = 114;;
let _PPC_INS_FSQRT = 115;;
let _PPC_INS_FSQRTS = 116;;
let _PPC_INS_FSUB = 117;;
let _PPC_INS_FSUBS = 118;;
let _PPC_INS_ICBI = 119;;
let _PPC_INS_ISEL = 120;;
let _PPC_INS_ISYNC = 121;;
let _PPC_INS_LA = 122;;
let _PPC_INS_LBZ = 123;;
let _PPC_INS_LBZU = 124;;
let _PPC_INS_LBZUX = 125;;
let _PPC_INS_LBZX = 126;;
let _PPC_INS_LD = 127;;
let _PPC_INS_LDARX = 128;;
let _PPC_INS_LDBRX = 129;;
let _PPC_INS_LDU = 130;;
let _PPC_INS_LDUX = 131;;
let _PPC_INS_LDX = 132;;
let _PPC_INS_LFD = 133;;
let _PPC_INS_LFDU = 134;;
let _PPC_INS_LFDUX = 135;;
let _PPC_INS_LFDX = 136;;
let _PPC_INS_LFIWAX = 137;;
let _PPC_INS_LFIWZX = 138;;
let _PPC_INS_LFS = 139;;
let _PPC_INS_LFSU = 140;;
let _PPC_INS_LFSUX = 141;;
let _PPC_INS_LFSX = 142;;
let _PPC_INS_LHA = 143;;
let _PPC_INS_LHAU = 144;;
let _PPC_INS_LHAUX = 145;;
let _PPC_INS_LHAX = 146;;
let _PPC_INS_LHBRX = 147;;
let _PPC_INS_LHZ = 148;;
let _PPC_INS_LHZU = 149;;
let _PPC_INS_LHZUX = 150;;
let _PPC_INS_LHZX = 151;;
let _PPC_INS_LI = 152;;
let _PPC_INS_LIS = 153;;
let _PPC_INS_LMW = 154;;
let _PPC_INS_LVEBX = 155;;
let _PPC_INS_LVEHX = 156;;
let _PPC_INS_LVEWX = 157;;
let _PPC_INS_LVSL = 158;;
let _PPC_INS_LVSR = 159;;
let _PPC_INS_LVX = 160;;
let _PPC_INS_LVXL = 161;;
let _PPC_INS_LWA = 162;;
let _PPC_INS_LWARX = 163;;
let _PPC_INS_LWAUX = 164;;
let _PPC_INS_LWAX = 165;;
let _PPC_INS_LWBRX = 166;;
let _PPC_INS_LWZ = 167;;
let _PPC_INS_LWZU = 168;;
let _PPC_INS_LWZUX = 169;;
let _PPC_INS_LWZX = 170;;
let _PPC_INS_MCRF = 171;;
let _PPC_INS_MFCR = 172;;
let _PPC_INS_MFCTR = 173;;
let _PPC_INS_MFFS = 174;;
let _PPC_INS_MFLR = 175;;
let _PPC_INS_MFMSR = 176;;
let _PPC_INS_MFOCRF = 177;;
let _PPC_INS_MFSPR = 178;;
let _PPC_INS_MFTB = 179;;
let _PPC_INS_MFVSCR = 180;;
let _PPC_INS_MSYNC = 181;;
let _PPC_INS_MTCRF = 182;;
let _PPC_INS_MTCTR = 183;;
let _PPC_INS_MTFSB0 = 184;;
let _PPC_INS_MTFSB1 = 185;;
let _PPC_INS_MTFSF = 186;;
let _PPC_INS_MTLR = 187;;
let _PPC_INS_MTMSR = 188;;
let _PPC_INS_MTMSRD = 189;;
let _PPC_INS_MTOCRF = 190;;
let _PPC_INS_MTSPR = 191;;
let _PPC_INS_MTVSCR = 192;;
let _PPC_INS_MULHD = 193;;
let _PPC_INS_MULHDU = 194;;
let _PPC_INS_MULHW = 195;;
let _PPC_INS_MULHWU = 196;;
let _PPC_INS_MULLD = 197;;
let _PPC_INS_MULLI = 198;;
let _PPC_INS_MULLW = 199;;
let _PPC_INS_NAND = 200;;
let _PPC_INS_NEG = 201;;
let _PPC_INS_NOP = 202;;
let _PPC_INS_ORI = 203;;
let _PPC_INS_NOR = 204;;
let _PPC_INS_OR = 205;;
let _PPC_INS_ORC = 206;;
let _PPC_INS_ORIS = 207;;
let _PPC_INS_POPCNTD = 208;;
let _PPC_INS_POPCNTW = 209;;
let _PPC_INS_RLDCL = 210;;
let _PPC_INS_RLDCR = 211;;
let _PPC_INS_RLDIC = 212;;
let _PPC_INS_RLDICL = 213;;
let _PPC_INS_RLDICR = 214;;
let _PPC_INS_RLDIMI = 215;;
let _PPC_INS_RLWIMI = 216;;
let _PPC_INS_RLWINM = 217;;
let _PPC_INS_RLWNM = 218;;
let _PPC_INS_SC = 219;;
let _PPC_INS_SLBIA = 220;;
let _PPC_INS_SLBIE = 221;;
let _PPC_INS_SLBMFEE = 222;;
let _PPC_INS_SLBMTE = 223;;
let _PPC_INS_SLD = 224;;
let _PPC_INS_SLW = 225;;
let _PPC_INS_SRAD = 226;;
let _PPC_INS_SRADI = 227;;
let _PPC_INS_SRAW = 228;;
let _PPC_INS_SRAWI = 229;;
let _PPC_INS_SRD = 230;;
let _PPC_INS_SRW = 231;;
let _PPC_INS_STB = 232;;
let _PPC_INS_STBU = 233;;
let _PPC_INS_STBUX = 234;;
let _PPC_INS_STBX = 235;;
let _PPC_INS_STD = 236;;
let _PPC_INS_STDBRX = 237;;
let _PPC_INS_STDCX = 238;;
let _PPC_INS_STDU = 239;;
let _PPC_INS_STDUX = 240;;
let _PPC_INS_STDX = 241;;
let _PPC_INS_STFD = 242;;
let _PPC_INS_STFDU = 243;;
let _PPC_INS_STFDUX = 244;;
let _PPC_INS_STFDX = 245;;
let _PPC_INS_STFIWX = 246;;
let _PPC_INS_STFS = 247;;
let _PPC_INS_STFSU = 248;;
let _PPC_INS_STFSUX = 249;;
let _PPC_INS_STFSX = 250;;
let _PPC_INS_STH = 251;;
let _PPC_INS_STHBRX = 252;;
let _PPC_INS_STHU = 253;;
let _PPC_INS_STHUX = 254;;
let _PPC_INS_STHX = 255;;
let _PPC_INS_STMW = 256;;
let _PPC_INS_STVEBX = 257;;
let _PPC_INS_STVEHX = 258;;
let _PPC_INS_STVEWX = 259;;
let _PPC_INS_STVX = 260;;
let _PPC_INS_STVXL = 261;;
let _PPC_INS_STW = 262;;
let _PPC_INS_STWBRX = 263;;
let _PPC_INS_STWCX = 264;;
let _PPC_INS_STWU = 265;;
let _PPC_INS_STWUX = 266;;
let _PPC_INS_STWX = 267;;
let _PPC_INS_SUBF = 268;;
let _PPC_INS_SUBFC = 269;;
let _PPC_INS_SUBFE = 270;;
let _PPC_INS_SUBFIC = 271;;
let _PPC_INS_SUBFME = 272;;
let _PPC_INS_SUBFZE = 273;;
let _PPC_INS_SYNC = 274;;
let _PPC_INS_TD = 275;;
let _PPC_INS_TDI = 276;;
let _PPC_INS_TLBIE = 277;;
let _PPC_INS_TLBIEL = 278;;
let _PPC_INS_TLBSYNC = 279;;
let _PPC_INS_TRAP = 280;;
let _PPC_INS_TW = 281;;
let _PPC_INS_TWI = 282;;
let _PPC_INS_VADDCUW = 283;;
let _PPC_INS_VADDFP = 284;;
let _PPC_INS_VADDSBS = 285;;
let _PPC_INS_VADDSHS = 286;;
let _PPC_INS_VADDSWS = 287;;
let _PPC_INS_VADDUBM = 288;;
let _PPC_INS_VADDUBS = 289;;
let _PPC_INS_VADDUHM = 290;;
let _PPC_INS_VADDUHS = 291;;
let _PPC_INS_VADDUWM = 292;;
let _PPC_INS_VADDUWS = 293;;
let _PPC_INS_VAND = 294;;
let _PPC_INS_VANDC = 295;;
let _PPC_INS_VAVGSB = 296;;
let _PPC_INS_VAVGSH = 297;;
let _PPC_INS_VAVGSW = 298;;
let _PPC_INS_VAVGUB = 299;;
let _PPC_INS_VAVGUH = 300;;
let _PPC_INS_VAVGUW = 301;;
let _PPC_INS_VCFSX = 302;;
let _PPC_INS_VCFUX = 303;;
let _PPC_INS_VCMPBFP = 304;;
let _PPC_INS_VCMPEQFP = 305;;
let _PPC_INS_VCMPEQUB = 306;;
let _PPC_INS_VCMPEQUH = 307;;
let _PPC_INS_VCMPEQUW = 308;;
let _PPC_INS_VCMPGEFP = 309;;
let _PPC_INS_VCMPGTFP = 310;;
let _PPC_INS_VCMPGTSB = 311;;
let _PPC_INS_VCMPGTSH = 312;;
let _PPC_INS_VCMPGTSW = 313;;
let _PPC_INS_VCMPGTUB = 314;;
let _PPC_INS_VCMPGTUH = 315;;
let _PPC_INS_VCMPGTUW = 316;;
let _PPC_INS_VCTSXS = 317;;
let _PPC_INS_VCTUXS = 318;;
let _PPC_INS_VEXPTEFP = 319;;
let _PPC_INS_VLOGEFP = 320;;
let _PPC_INS_VMADDFP = 321;;
let _PPC_INS_VMAXFP = 322;;
let _PPC_INS_VMAXSB = 323;;
let _PPC_INS_VMAXSH = 324;;
let _PPC_INS_VMAXSW = 325;;
let _PPC_INS_VMAXUB = 326;;
let _PPC_INS_VMAXUH = 327;;
let _PPC_INS_VMAXUW = 328;;
let _PPC_INS_VMHADDSHS = 329;;
let _PPC_INS_VMHRADDSHS = 330;;
let _PPC_INS_VMINFP = 331;;
let _PPC_INS_VMINSB = 332;;
let _PPC_INS_VMINSH = 333;;
let _PPC_INS_VMINSW = 334;;
let _PPC_INS_VMINUB = 335;;
let _PPC_INS_VMINUH = 336;;
let _PPC_INS_VMINUW = 337;;
let _PPC_INS_VMLADDUHM = 338;;
let _PPC_INS_VMRGHB = 339;;
let _PPC_INS_VMRGHH = 340;;
let _PPC_INS_VMRGHW = 341;;
let _PPC_INS_VMRGLB = 342;;
let _PPC_INS_VMRGLH = 343;;
let _PPC_INS_VMRGLW = 344;;
let _PPC_INS_VMSUMMBM = 345;;
let _PPC_INS_VMSUMSHM = 346;;
let _PPC_INS_VMSUMSHS = 347;;
let _PPC_INS_VMSUMUBM = 348;;
let _PPC_INS_VMSUMUHM = 349;;
let _PPC_INS_VMSUMUHS = 350;;
let _PPC_INS_VMULESB = 351;;
let _PPC_INS_VMULESH = 352;;
let _PPC_INS_VMULEUB = 353;;
let _PPC_INS_VMULEUH = 354;;
let _PPC_INS_VMULOSB = 355;;
let _PPC_INS_VMULOSH = 356;;
let _PPC_INS_VMULOUB = 357;;
let _PPC_INS_VMULOUH = 358;;
let _PPC_INS_VNMSUBFP = 359;;
let _PPC_INS_VNOR = 360;;
let _PPC_INS_VOR = 361;;
let _PPC_INS_VPERM = 362;;
let _PPC_INS_VPKPX = 363;;
let _PPC_INS_VPKSHSS = 364;;
let _PPC_INS_VPKSHUS = 365;;
let _PPC_INS_VPKSWSS = 366;;
let _PPC_INS_VPKSWUS = 367;;
let _PPC_INS_VPKUHUM = 368;;
let _PPC_INS_VPKUHUS = 369;;
let _PPC_INS_VPKUWUM = 370;;
let _PPC_INS_VPKUWUS = 371;;
let _PPC_INS_VREFP = 372;;
let _PPC_INS_VRFIM = 373;;
let _PPC_INS_VRFIN = 374;;
let _PPC_INS_VRFIP = 375;;
let _PPC_INS_VRFIZ = 376;;
let _PPC_INS_VRLB = 377;;
let _PPC_INS_VRLH = 378;;
let _PPC_INS_VRLW = 379;;
let _PPC_INS_VRSQRTEFP = 380;;
let _PPC_INS_VSEL = 381;;
let _PPC_INS_VSL = 382;;
let _PPC_INS_VSLB = 383;;
let _PPC_INS_VSLDOI = 384;;
let _PPC_INS_VSLH = 385;;
let _PPC_INS_VSLO = 386;;
let _PPC_INS_VSLW = 387;;
let _PPC_INS_VSPLTB = 388;;
let _PPC_INS_VSPLTH = 389;;
let _PPC_INS_VSPLTISB = 390;;
let _PPC_INS_VSPLTISH = 391;;
let _PPC_INS_VSPLTISW = 392;;
let _PPC_INS_VSPLTW = 393;;
let _PPC_INS_VSR = 394;;
let _PPC_INS_VSRAB = 395;;
let _PPC_INS_VSRAH = 396;;
let _PPC_INS_VSRAW = 397;;
let _PPC_INS_VSRB = 398;;
let _PPC_INS_VSRH = 399;;
let _PPC_INS_VSRO = 400;;
let _PPC_INS_VSRW = 401;;
let _PPC_INS_VSUBCUW = 402;;
let _PPC_INS_VSUBFP = 403;;
let _PPC_INS_VSUBSBS = 404;;
let _PPC_INS_VSUBSHS = 405;;
let _PPC_INS_VSUBSWS = 406;;
let _PPC_INS_VSUBUBM = 407;;
let _PPC_INS_VSUBUBS = 408;;
let _PPC_INS_VSUBUHM = 409;;
let _PPC_INS_VSUBUHS = 410;;
let _PPC_INS_VSUBUWM = 411;;
let _PPC_INS_VSUBUWS = 412;;
let _PPC_INS_VSUM2SWS = 413;;
let _PPC_INS_VSUM4SBS = 414;;
let _PPC_INS_VSUM4SHS = 415;;
let _PPC_INS_VSUM4UBS = 416;;
let _PPC_INS_VSUMSWS = 417;;
let _PPC_INS_VUPKHPX = 418;;
let _PPC_INS_VUPKHSB = 419;;
let _PPC_INS_VUPKHSH = 420;;
let _PPC_INS_VUPKLPX = 421;;
let _PPC_INS_VUPKLSB = 422;;
let _PPC_INS_VUPKLSH = 423;;
let _PPC_INS_VXOR = 424;;
let _PPC_INS_WAIT = 425;;
let _PPC_INS_XOR = 426;;
let _PPC_INS_XORI = 427;;
let _PPC_INS_XORIS = 428;;
let _PPC_INS_BC = 429;;
let _PPC_INS_BCA = 430;;
let _PPC_INS_BCCTR = 431;;
let _PPC_INS_BCCTRL = 432;;
let _PPC_INS_BCLA = 433;;
let _PPC_INS_BCLR = 434;;
let _PPC_INS_BCLRL = 435;;
let _PPC_INS_MAX = 436;;

(*  Group of PPC instructions *)

let _PPC_GRP_INVALID = 0;;
let _PPC_GRP_ALTIVEC = 1;;
let _PPC_GRP_MODE32 = 2;;
let _PPC_GRP_MODE64 = 3;;
let _PPC_GRP_BOOKE = 4;;
let _PPC_GRP_NOTBOOKE = 5;;
let _PPC_GRP_JUMP = 6;;
let _PPC_GRP_MAX = 7;;
