ENTITY_DEFS = {
    ['player'] = {
        width = 19,
        height = 19,
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
    },
    ['skeleton'] = {
        width = 16,
        height = 16,
        texture = 'entities',
        health = 1,
        touchDamage = 1,
        scorePoints = 10,
        animations = {
            ['walk-left'] = {
                frames = {22, 23, 24, 23},
                interval = 0.2
            },
            ['walk-right'] = {
                frames = {34, 35, 36, 35},
                interval = 0.2
            },
            ['walk-down'] = {
                frames = {10, 11, 12, 11},
                interval = 0.2
            },
            ['walk-up'] = {
                frames = {46, 47, 48, 47},
                interval = 0.2
            },
            ['idle-left'] = {
                frames = {23}
            },
            ['idle-right'] = {
                frames = {35}
            },
            ['idle-down'] = {
                frames = {11}
            },
            ['idle-up'] = {
                frames = {47}
            }
        }
    }
}
