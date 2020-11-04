botl.ana.hfst: botl.gen.hfst
	hfst-invert botl.gen.hfst -o botl.ana.hfst

botl.gen.hfst: botl.lexd.hfst botl.twol.hfst
	hfst-compose-intersect botl.lexd.hfst botl.twol.hfst -o botl.gen.hfst

botl.lexd.hfst: botl.lexd
	lexd botl.lexd | hfst-txt2fst -o botl.lexd.hfst

botl.twol.hfst: botl.twol
	hfst-twolc botl.twol -o botl.twol.hfst