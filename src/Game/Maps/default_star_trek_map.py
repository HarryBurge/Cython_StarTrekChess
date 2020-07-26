from src.Game.Pieces.StarTrekChess import bishop_s, castle_s, king_s, knight_s, pawn_s, queen_s
from src.Game.attack_board_class import AttackBoard

attack_boards_array = [[AttackBoard(0,0,0,'White'),AttackBoard(4,0,0,'Black')],
                       [(0,4,0), (4,4,0)],
                       [(0,7,1), (4,7,1)],
                       [AttackBoard(0,8,2,'White'), AttackBoard(4,8,2,'White')]]

map_array = [[[castle_s.Castle(team='Black'),knight_s.Knight(team='Black'),'x','x',knight_s.Knight(team='Black'),castle_s.Castle(team='Black')],
              [pawn_s.Pawn([0,1], team='Black'),pawn_s.Pawn([0,1], team='Black'),'x','x',pawn_s.Pawn([0,1], team='Black'),pawn_s.Pawn([0,1], team='Black')],
              ['x','x','x','x','x','x'],
              ['x','x','x','x','x','x'],
              ['x','x','x','x','x','x'],
              ['x','x','x','x','x','x'],
              ['x','x','x','x','x','x'],
              ['x','x','x','x','x','x'],
              ['x','x','x','x','x','x'],
              ['x','x','x','x','x','x']],

             [['x','x','x','x','x','x'],
              ['x',bishop_s.Bishop(team='Black'),queen_s.Queen(team='Black'),king_s.King(team='Black'),bishop_s.Bishop(team='Black'),'x'],
              ['x',pawn_s.Pawn([0,1], team='Black'),pawn_s.Pawn([0,1], team='Black'),pawn_s.Pawn([0,1], team='Black'),pawn_s.Pawn([0,1], team='Black'),'x'],
              ['x','@','@','@','@','x'],
              ['x','@','@','@','@','x'],
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
              [pawn_s.Pawn([0,-1], team='White'),pawn_s.Pawn([0,-1], team='White'),'x','x',pawn_s.Pawn([0,-1], team='White'),pawn_s.Pawn([0,-1], team='White')],
              [castle_s.Castle(team='White'),knight_s.Knight(team='White'),'x','x',knight_s.Knight(team='White'),castle_s.Castle(team='White')]],

             [['x','x','x','x','x','x'],
              ['x','x','x','x','x','x'],
              ['x','x','x','x','x','x'],
              ['x','x','x','x','x','x'],
              ['x','x','x','x','x','x'],
              ['x','@','@','@','@','x'],
              ['x','@','@','@','@','x'],
              ['x',pawn_s.Pawn([0,-1], team='White'),pawn_s.Pawn([0,-1], team='White'),pawn_s.Pawn([0,-1], team='White'),pawn_s.Pawn([0,-1], team='White'),'x'],
              ['x',bishop_s.Bishop(team='White'),queen_s.Queen(team='White'),king_s.King(team='White'),bishop_s.Bishop(team='White'),'x'],
              ['x','x','x','x','x','x']]]