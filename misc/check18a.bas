
DECLARE SUB import (filename AS STRING)

DECLARE SUB pathparts (subject AS STRING, path AS STRING, filename AS STRING, ext AS STRING)

DECLARE SUB loadbsv (filename AS STRING, img() AS INTEGER)

SCREEN 7, 0, 0, 0
WIDTH 40
VIEW PRINT 1 TO 25
COLOR 15, 0
CLS

PRINT "sprites.txt"
import "sprites.txt"

PRINT "logos.txt"
import "logos.txt"

PRINT "font.txt"
import "font.txt"

SUB import (filename AS STRING)

	DIM path AS STRING
	DIM subject AS STRING
	DIM ext AS STRING
	
	DIM buffer AS STRING

	pathparts filename, path, subject, ext
       
	DIM filemode AS INTEGER
	filemode = FREEFILE

	REDIM bsv(0 TO 0) AS INTEGER
	OPEN "capture\" + subject + ext FOR INPUT AS #filemode
	WHILE NOT (EOF(filemode))
		LINE INPUT #filemode, buffer
		PRINT buffer
		loadbsv "bsv\" + buffer, bsv()
	WEND
	CLOSE #filemode

END SUB

SUB loadbsv (filename AS STRING, bsv() AS INTEGER)
	
	DIM truew AS INTEGER
	DIM trueh AS INTEGER
       
	DIM magic AS INTEGER
	
	DIM header AS STRING
	DIM buffer AS STRING
	
	DIM checksum AS STRING
	checksum = STRING$(1, 0)
	
	DIM z AS INTEGER
	DIM w AS INTEGER
	DIM h AS INTEGER
		
	DIM filemode AS INTEGER
	filemode = FREEFILE
	
	OPEN filename FOR BINARY AS #filemode
	
	header = STRING$(11, 0)
	GET #filemode, 1, header
	
	magic = ASC(LEFT$(header, 1)) = &HFD
	IF magic = 0 THEN
		close #filemode
		EXIT SUB
	END IF
	
	z = CVI(MID$(header, 6, 2)) AND 32767
	w = CVI(MID$(header, 8, 2)) AND 32767
	h = CVI(MID$(header, 10, 2)) AND 32767

	IF w = 25 AND h = 25 THEN
		truew = 24
		trueh = 24
	ELSE
		truew = w
		trueh = h
	END IF

	buffer = STRING$(LOF(filemode) - LEN(header) - 1, 0)
	GET #filemode, 1 + LEN(header), buffer
	GET #filemode, LOF(filemode), checksum
	CLOSE #filemode
	
	DIM cb AS INTEGER
	DIM x AS INTEGER

	FOR y = 0 TO h - 1 STEP 1
		FOR b = 0 TO 3 STEP 1
			cb = 0
			FOR x = 0 TO w - 1 STEP 1
				IF (x AND 7) = 0 THEN
					cb = ASC(LEFT$(buffer, 1))
					buffer = MID$(buffer, 2)
				END IF
				PSET (x, y), POINT(x, y) XOR (bb AND -cb \ &H80)
				cb = cb + cb AND &HFF
			NEXT x
		NEXT b
	NEXT y

	REDIM bsv(0 TO truew * trueh / 2 + 5)

	GET (0, 0)-(truew - 1, trueh - 1), bsv(0)
       
	DEF SEG = VARSEG(bsv(0))
	BSAVE "port18a\shades\" + filename, VARPTR(bsv(0)), LEN(bsv(0))
       
	PRINT "port18a\shades\" + filename
       
	FOR y = 0 TO trueh - 1 STEP 1
	FOR x = 0 TO truew - 1 STEP 1
		PSET (x, y), (POINT(x, y) = 0) AND 15
	NEXT x
	NEXT y
	GET (0, 0)-(truew - 1, trueh - 1), bsv(0)

	DEF SEG = VARSEG(bsv(0))
	BSAVE "port18a\erasure\" + filename, VARPTR(bsv(0)), LEN(bsv(0))
       
	PRINT "port18a\erasure\" + filename

END SUB

SUB pathparts (subject AS STRING, path AS STRING, filename AS STRING, ext AS STRING)
	
	path = STRING$(0, 0)
	filename = subject
	ext = STRING$(0, 0)
	
	WHILE INSTR(1, filename, "\") > 0
		path = path + LEFT$(path, INSTR(1, filename, "\"))
		filename = MID$(path, INSTR(1, filename, "\") + 1)
	WEND
	
	IF INSTR(1, filename, ".") > 0 THEN
		ext = MID$(filename, INSTR(1, filename, "."))
		filename = LEFT$(filename, INSTR(1, filename, ".") - 1)
	END IF
END SUB

