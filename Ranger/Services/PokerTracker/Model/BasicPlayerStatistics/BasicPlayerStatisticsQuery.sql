SELECT
  (
    tourney_hand_player_statistics.id_player
  ) AS "id_player",
  (player_real.id_site) AS "id_site",
  (player.player_name) AS "str_player_name",
  (
    sum(
      (
        CASE when(
          tourney_hand_player_statistics.flg_vpip
        ) THEN 1 ELSE 0 end
      )
    )
  ) AS "cnt_vpip",
  (
    sum(
      (
        CASE when(
          tourney_hand_player_statistics.id_hand > 0
        ) THEN 1 ELSE 0 end
      )
    )
  ) AS "cnt_hands",
  (
    sum(
      (
        CASE when(lookup_actions_p.action = '') THEN 1 ELSE 0 end
      )
    )
  ) AS "cnt_walks",
  (
    sum(
      (
        CASE when(
          tourney_hand_player_statistics.cnt_p_raise > 0
        ) THEN 1 ELSE 0 end
      )
    )
  ) AS "cnt_pfr",
  (
    sum(
      (
        CASE when(
          lookup_actions_p.action LIKE '__%'
          OR (
            lookup_actions_p.action LIKE '_'
            AND (
              tourney_hand_player_statistics.amt_before > (
                tourney_blinds.amt_bb + tourney_hand_player_statistics.amt_ante
              )
            )
            AND (
              tourney_hand_player_statistics.amt_p_raise_facing < (
                tourney_hand_player_statistics.amt_before - (
                  tourney_hand_player_statistics.amt_blind + tourney_hand_player_statistics.amt_ante
                )
              )
            )
            AND (
              tourney_hand_player_statistics.flg_p_open_opp
              OR tourney_hand_player_statistics.cnt_p_face_limpers > 0
              OR tourney_hand_player_statistics.flg_p_3bet_opp
              OR tourney_hand_player_statistics.flg_p_4bet_opp
            )
          )
        ) THEN 1 ELSE 0 end
      )
    )
  ) AS "cnt_pfr_opp"
FROM
  tourney_table_type,
  tourney_summary,
  tourney_hand_player_statistics,
  player player_real,
  player,
  lookup_actions lookup_actions_p,
  tourney_blinds
WHERE
  (
    player_real.id_player = tourney_hand_player_statistics.id_player_real
  )
  AND (
    player.id_player = tourney_hand_player_statistics.id_player
  )
  AND (
    lookup_actions_p.id_action = tourney_hand_player_statistics.id_action_p
  )
  AND (
    tourney_blinds.id_blinds = tourney_hand_player_statistics.id_blinds
  )
  AND (
    tourney_summary.id_tourney = tourney_hand_player_statistics.id_tourney
  )
  AND (
    tourney_summary.id_tourney = tourney_hand_player_statistics.id_tourney
    AND tourney_summary.id_table_type = tourney_table_type.id_table_type
  )
  AND (
    (
      tourney_hand_player_statistics.id_gametype = 1
    )
    AND
    (
      tourney_summary.tourney_no LIKE '$_TOURNEY_NUMBER'
    )
    AND
    (
      tourney_table_type.description LIKE 'MTT %'
    )
  )
  AND (
    $_WHERE_CONDITION
  )
GROUP BY
  (
    tourney_hand_player_statistics.id_player
  ),
  (player_real.id_site),
  (player.player_name)
