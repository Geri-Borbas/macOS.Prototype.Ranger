SELECT
    tourney_hand_summary.id_hand,
    tourney_hand_summary.hand_no,
    tourney_hand_summary.date_played,
    tourney_blinds.blinds_name
FROM
    tourney_hand_summary,
    tourney_blinds
WHERE

    -- Filter for given `tourney_no`
    (
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
    )
AND

    -- Match `blind_name` for given `id_blinds`
    (
        tourney_blinds.id_blinds = tourney_hand_summary.id_blinds
    )
ORDER BY
    tourney_hand_summary.date_played DESC
