SELECT
  (
    tourney_hand_player_statistics.id_player
  ) as "id_player",
  (player_real.id_site) as "id_site",
  (player.player_name) as "str_player_name",
  (
    sum(
      (
        case when(
          tourney_hand_player_statistics.id_hand > 0
        ) then 1 else 0 end
      )
    )
  ) as "cnt_hands",
  (
    sum(
      (
        case when(
          tourney_hand_player_statistics.flg_vpip
        ) then 1 else 0 end
      )
    )
  ) as "cnt_vpip",
  (
    sum(
      (
        case when(lookup_actions_p.action = '') then 1 else 0 end
      )
    )
  ) as "cnt_walks",
  (
    sum(
      (
        case when(
          tourney_hand_player_statistics.cnt_p_raise > 0
        ) then 1 else 0 end
      )
    )
  ) as "cnt_pfr",
  (
    sum(
      (
        case when(
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
        ) then 1 else 0 end
      )
    )
  ) as "cnt_pfr_opp",
  (
    sum(
      (
        case when(
          tourney_hand_player_statistics.flg_steal_att
        ) then 1 else 0 end
      )
    )
  ) as "cnt_steal_att",
  (
    sum(
      (
        case when(
          tourney_hand_player_statistics.flg_steal_opp
        ) then 1 else 0 end
      )
    )
  ) as "cnt_steal_opp",
  (
    sum(
      (
        case when(
          tourney_hand_player_statistics.flg_blind_def_opp
          AND lookup_actions_p.action = 'F'
        ) then 1 else 0 end
      )
    )
  ) as "cnt_steal_def_action_fold",
  (
    sum(
      (
        case when(
          tourney_hand_player_statistics.flg_blind_def_opp
        ) then 1 else 0 end
      )
    )
  ) as "cnt_steal_def_opp",
  (
    sum(
      (
        case when(
          tourney_hand_player_statistics.flg_blind_def_opp
          AND lookup_actions_p.action LIKE 'C%'
        ) then 1 else 0 end
      )
    )
  ) as "cnt_steal_def_action_call",
  (
    sum(
      (
        case when(
          tourney_hand_player_statistics.flg_blind_def_opp
          AND lookup_actions_p.action LIKE 'R%'
        ) then 1 else 0 end
      )
    )
  ) as "cnt_steal_def_action_raise",
  (
    sum(
      (
        case when(
          tourney_hand_player_statistics.flg_blind_def_opp
          AND tourney_hand_player_statistics.flg_p_3bet_opp
        ) then 1 else 0 end
      )
    )
  ) as "cnt_steal_def_3bet_opp",
  (
    sum(
      (
        case when(
          tourney_hand_player_statistics.flg_p_3bet
        ) then 1 else 0 end
      )
    )
  ) as "cnt_p_3bet",
  (
    sum(
      (
        case when(
          tourney_hand_player_statistics.flg_p_3bet_opp
        ) then 1 else 0 end
      )
    )
  ) as "cnt_p_3bet_opp",
  (
    sum(
      (
        case when(
          tourney_hand_player_statistics.enum_p_3bet_action = 'F'
        ) then 1 else 0 end
      )
    )
  ) as "cnt_p_3bet_def_action_fold",
  (
    sum(
      (
        case when(
          tourney_hand_player_statistics.flg_p_3bet_def_opp
        ) then 1 else 0 end
      )
    )
  ) as "cnt_p_3bet_def_opp",
  (
    sum(
      (
        case when(
          tourney_hand_player_statistics.enum_p_3bet_action = 'C'
        ) then 1 else 0 end
      )
    )
  ) as "cnt_p_3bet_def_action_call",
  (
    sum(
      (
        case when(
          tourney_hand_player_statistics.flg_p_4bet
        ) then 1 else 0 end
      )
    )
  ) as "cnt_p_4bet",
  (
    sum(
      (
        case when(
          tourney_hand_player_statistics.flg_p_4bet_opp
        ) then 1 else 0 end
      )
    )
  ) as "cnt_p_4bet_opp",
  (
    sum(
      (
        case when(
          tourney_hand_player_statistics.flg_f_cbet
        ) then 1 else 0 end
      )
    )
  ) as "cnt_f_cbet",
  (
    sum(
      (
        case when(
          tourney_hand_player_statistics.flg_f_cbet_opp
        ) then 1 else 0 end
      )
    )
  ) as "cnt_f_cbet_opp",
  (
    sum(
      (
        case when(
          tourney_hand_player_statistics.enum_f_cbet_action = 'F'
        ) then 1 else 0 end
      )
    )
  ) as "cnt_f_cbet_def_action_fold",
  (
    sum(
      (
        case when(
          tourney_hand_player_statistics.flg_f_cbet_def_opp
        ) then 1 else 0 end
      )
    )
  ) as "cnt_f_cbet_def_opp",
  (
    sum(
      (
        case when(
          tourney_hand_player_statistics.enum_f_cbet_action = 'C'
        ) then 1 else 0 end
      )
    )
  ) as "cnt_f_cbet_def_action_call",
  (
    sum(
      (
        case when(
          tourney_hand_player_statistics.enum_f_cbet_action = 'R'
        ) then 1 else 0 end
      )
    )
  ) as "cnt_f_cbet_def_action_raise",
  (
    sum(
      (
        case when(
          tourney_hand_player_statistics.flg_t_cbet
        ) then 1 else 0 end
      )
    )
  ) as "cnt_t_cbet",
  (
    sum(
      (
        case when(
          tourney_hand_player_statistics.flg_t_cbet_opp
        ) then 1 else 0 end
      )
    )
  ) as "cnt_t_cbet_opp",
  (
    sum(
      (
        case when(
          tourney_hand_player_statistics.enum_t_cbet_action = 'F'
        ) then 1 else 0 end
      )
    )
  ) as "cnt_t_cbet_def_action_fold",
  (
    sum(
      (
        case when(
          tourney_hand_player_statistics.flg_t_cbet_def_opp
        ) then 1 else 0 end
      )
    )
  ) as "cnt_t_cbet_def_opp",
  (
    sum(
      (
        case when(
          tourney_hand_player_statistics.enum_t_cbet_action = 'C'
        ) then 1 else 0 end
      )
    )
  ) as "cnt_t_cbet_def_action_call",
  (
    sum(
      (
        case when(
          tourney_hand_player_statistics.enum_t_cbet_action = 'R'
        ) then 1 else 0 end
      )
    )
  ) as "cnt_t_cbet_def_action_raise",
  (
    sum(
      (
        case when(
          tourney_hand_player_statistics.flg_showdown
        ) then 1 else 0 end
      )
    )
  ) as "cnt_wtsd",
  (
    sum(
      (
        case when(
          tourney_hand_player_statistics.flg_f_saw
        ) then 1 else 0 end
      )
    )
  ) as "cnt_f_saw",
  (
    sum(
      (
        case when(
          tourney_hand_player_statistics.flg_showdown
          AND tourney_hand_player_statistics.flg_won_hand
        ) then 1 else 0 end
      )
    )
  ) as "cnt_wtsd_won",
  (
    sum(
      (
        case when(
          tourney_hand_player_statistics.flg_won_hand
          AND tourney_hand_player_statistics.flg_f_saw
        ) then 1 else 0 end
      )
    )
  ) as "cnt_f_saw_won"
FROM
  tourney_table_type,
  tourney_hand_player_statistics,
  player player_real,
  player,
  lookup_actions lookup_actions_p,
  tourney_blinds,
  tourney_summary
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
      (
        (
          (
            CASE WHEN tourney_summary.currency = 'SEK' THEN (tourney_summary.amt_buyin * 0.15) ELSE (
              CASE WHEN tourney_summary.currency = 'INR' THEN (
                tourney_summary.amt_buyin * 0.020
              ) ELSE (
                CASE WHEN tourney_summary.currency = 'XSC' THEN 0.0 ELSE (
                  CASE WHEN tourney_summary.currency = 'PLY' THEN 0.0 ELSE tourney_summary.amt_buyin END
                ) END
              ) END
            ) END
          ) <= 22.01
        )
        AND tourney_summary.id_gametype = 1
      )
      OR tourney_summary.id_gametype <> 1
    )
  ) 
  AND (
    $_WHERE_CONDITION
  )
  AND (
    tourney_summary.tourney_no LIKE '$_TOURNEY_NUMBER'
  )
GROUP BY
  (
    tourney_hand_player_statistics.id_player
  ),
  (player_real.id_site),
  (player.player_name)
