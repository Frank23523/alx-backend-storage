-- SQL script that creates the stored procedure
-- ComputeAverageWeightedScoreForUser according to requirements
DROP PROCEDURE IF EXISTS ComputeAverageWeightedScoreForUser;
DELIMITER $$
CREATE PROCEDURE ComputeAverageWeightedScoreForUser(
    IN p_user_id INT
)
BEGIN
    DECLARE v_avg_weighted_score FLOAT;

    -- Compute the average weighted score
    SELECT SUM(c.score * p.weight) / SUM(p.weight)
    INTO v_avg_weighted_score
    FROM corrections c
    JOIN projects p ON c.project_id = p.id
    WHERE c.user_id = p_user_id;

    -- Update the user's average_score
    UPDATE users
    SET average_score = v_avg_weighted_score
    WHERE id = p_user_id;
END $$
DELIMITER ;
