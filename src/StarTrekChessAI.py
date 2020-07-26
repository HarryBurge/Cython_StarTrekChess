from src.Game.controller_class import GameController

import threading
import importlib


def main():
    #'src.Game.ControlLoops.default_star_trek_controlloop_1v1'

    #'src.Game.Maps.default_star_trek_map'
    #'src.Game.Maps.checkmate.check_map'

    controls = []

    for i in range(1):
        controls.append(GameController('game{}'.format(i), 'src.Game.ControlLoops.star_trek_controlloop_1vbot', 'src.Game.Maps.default_star_trek_map', 'src.AI.AI\'s.testAI'))

    visual_file = importlib.import_module('src.Visualliser.visualliser2')

    visuals = visual_file.Visualliser(controls, option_style='2dviewHorizontal-allHorizontal')

    for i in controls:
        i.set_visualliser(visuals)

    for i in controls:
        threading._start_new_thread(i.run, ())

    visuals.run()

    print('Use __main__.py to be able to test due to the cwd in the right place, change this main to actually to test code')
