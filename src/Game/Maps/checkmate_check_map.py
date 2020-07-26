from src.Game.Pieces.StarTrekChess import bishop_s, castle_s, king_s, knight_s, pawn_s, queen_s

map_array = [[['@','@','x','x','@','@'],
              ['@','@','x','x','@','@'],
              ['x','x','x','x','x','x'],
              ['x','x','x','x','x','x'],
              ['x','x','x','x','x','x'],
              ['x','x','x','x','x','x'],
              ['x','x','x','x','x','x'],
              ['x','x','x','x','x','x'],
              ['x','x','x','x','x','x'],
              ['x','x','x','x','x','x']],

             [['x','x','x','x','x','x'],
              ['x',queen_s.Queen(team='White'),queen_s.Queen(team='White'),queen_s.Queen(team='White'),queen_s.Queen(team='White'),'x'],
              ['x','@','@',king_s.King(team='Black'),'@','x'],
              ['x',queen_s.Queen(team='Black'),'@','@','@','x'],
              ['x','@','@',queen_s.Queen(team='White'),'@','x'],
              ['x','x','x','x','x','x'],
              ['x','x','x','x','x','x'],
              ['x','x','x','x','x','x'],
              ['x','x','x','x','x','x'],
              ['x','x','x','x','x','x']],

             [['x','x','x','x','x','x'],
              ['x','x','x','x','x','x'],
              ['x','x','x','x','x','x'],
              ['x','@','@','@','@','x'],
              ['x','@','@','@','@','x'],
              ['x','@','@','@','@','x'],
              ['x','@','@','@','@','x'],
              ['x','x','x','x','x','x'],
              ['@','@','x','x','@','@'],
              ['@','@','x','x','@','@']],

             [['x','x','x','x','x','x'],
              ['x','x','x','x','x','x'],
              ['x','x','x','x','x','x'],
              ['x','x','x','x','x','x'],
              ['x','x','x','x','x','x'],
              ['x','@','@','@','@','x'],
              ['x','@','@','@','@','x'],
              ['x','@','@','@','@','x'],
              ['x','@','@',king_s.King(team='White'),'@','x'],
              ['x','x','x','x','x','x']]]