import time
import copy

from random import randint

from src.Game.Pieces.StarTrekChess.king_s import King
from src.Game.Pieces.StarTrekChess.pawn_s import Pawn


class ControlLoop:

    def __init__(self):
        self.players = ['White', 'Black']
        self.turn = 0

    def run(self, GameController):

        loop = True
        time.sleep(2)

        while loop:
            time.sleep(0.2)

            if len(GameController.get_all_pieces())-1 > 0:
                selected_piece = GameController.get_all_pieces()[randint(0, len(GameController.get_all_pieces())-1)]
                coords1 = selected_piece[0]
                valid_moves = selected_piece[1].valid_move_coords(GameController.get_map(), *coords1)

                if len(valid_moves)-1 > 0:
                    coords2 = valid_moves[randint(0, len(valid_moves)-1)]['coords']

                    GameController.clicked(*coords1)
                    GameController.clicked(*coords2)


            if len(GameController.instructions) == 1:

                if GameController.show_valid_moves(*GameController.instructions[0], self.players[self.turn]):
                    pass
                else:
                    print('First choice is wrong. Still ' + self.players[self.turn] + '\'s turn.')
                    GameController.instructions = []


            elif len(GameController.instructions) == 2:

                if GameController.do_move(*GameController.instructions[0], *GameController.instructions[1], self.players[self.turn], [Pawn], King):
                    if self.turn < len(self.players) - 1:
                        self.turn += 1
                    else:
                        self.turn = 0

                else:
                    print('Bad second choice. Still ' + self.players[self.turn] + '\'s turn.')
                    GameController.update_board(GameController.get_map())

                GameController.instructions = []


            if GameController.is_in_check(self.players[self.turn], King):
                print(self.players[self.turn] + ' is in check')

                if GameController.is_in_checkmate(self.players[self.turn], King):
                    print(self.players[self.turn] + ' is in checkmate')
                    loop = False