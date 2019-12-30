SELECT
    tourney_hand_player_statistics.id_tourney,
    tourney_hand_player_statistics.id_player,
    tourney_hand_player_statistics.id_hand,
    player.player_name,
    player.player_name_search,
    tourney_hand_summary.hand_no,
    tourney_hand_player_statistics.flg_hero,
    tourney_hand_player_statistics.position,
    tourney_hand_player_statistics.seat,
    tourney_hand_player_statistics.amt_before,
    tourney_hand_player_statistics.amt_blind,
    tourney_hand_player_statistics.amt_ante,
    tourney_hand_player_statistics.amt_won
FROM
    tourney_hand_player_statistics,
    player,
    tourney_hand_summary
WHERE

    -- Filter latest `id_hand` for given `tourney_no`
    (
        tourney_hand_player_statistics.id_hand =

        -- Get latest `id_hand` for `id_tourney`
        (
            SELECT
                tourney_hand_summary.id_hand
            FROM
                tourney_hand_summary
            WHERE
                  tourney_hand_summary.id_tourney =

                  -- Get `id_tourney` for `tourney_no`
                  (
                      SELECT
                          tourney_summary.id_tourney
                      FROM
                          tourney_summary
                      WHERE
                          tourney_summary.tourney_no = '$_TOURNEY_NUMBER'
                  )

            ORDER BY
                  tourney_hand_summary.date_played ASC
            LIMIT 1
        )
    )
AND

    -- Match `player_name` for given `id_player`
    (
        player.id_player = tourney_hand_player_statistics.id_player
    )
AND

    -- Match `hand_no` for given `id_hand`
    (
        tourney_hand_summary.id_hand = tourney_hand_player_statistics.id_hand
    )
ORDER BY
    tourney_hand_player_statistics.seat ASC
