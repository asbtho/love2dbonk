ENTITY_DEFS = {
    ['player'] = {
        walkSpeed = PLAYER_WALK_SPEED,
        animations = {
            ['walk-left'] = {
                frames = {1, 2, 3, 4, 5, 6, 7, 8},
                interval = 0.155,
                texture = 'soldier-walk-left'
            },
            ['walk-right'] = {
                frames = {8, 7, 6, 5, 4, 3, 2, 1},
                interval = 0.15,
                texture = 'soldier-walk-right'
            },
            ['walk-down'] = {
                frames = {1, 2, 3, 4, 5, 6, 7, 8},
                interval = 0.15,
                texture = 'soldier-walk-right'
            },
            ['walk-up'] = {
                frames = {8, 7, 6, 5, 4, 3, 2, 1},
                interval = 0.15,
                texture = 'soldier-walk-left'
            },
            ['idle-left'] = {
                frames = {1},
                texture = 'soldier-walk-left'
            },
            ['idle-right'] = {
                frames = {1},
                texture = 'soldier-walk-right'
            },
            ['idle-down'] = {
                frames = {1},
                texture = 'soldier-walk-right'
            },
            ['idle-up'] = {
                frames = {1},
                texture = 'soldier-walk-left'
            }
        }
    }
}
