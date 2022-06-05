#!/usr/bin/bash

# clear
dmd vita.d helper.d parser.d lexer.d node.d Object/datatype.d lib/builtins.d Object/strings.d Object/numbers.d Object/boolean.d Object/functions.d Object/lists.d Object/dictionary.d Object/bytes.d Object/classes.d Modules/fs.d Modules/files.d Modules/math.d Modules/random.d Modules/time.d Modules/socket.d Modules/env.d
./vita main.vt

