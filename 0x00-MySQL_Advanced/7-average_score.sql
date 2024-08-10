-- SQL script to create a stored procedure ComputeAverageScoreForUser
DROP PROCEDURE IF EXISTS ComputeAverageScoreForUser;
DELIMITER $$
CREATE PROCEDURE ComputeAverageScoreForUser(
    IN p_user_id INT
)
BEGIN
    DECLARE v_avg_score FLOAT;
    
    -- Compute the average score
    SELECT AVG(score) INTO v_avg_score
    FROM corrections
    WHERE user_id = p_user_id;
    
    -- Update the user's average_score
    UPDATE users
    SET average_score = v_avg_score
    WHERE id = p_user_id;
END $$
DELIMITER ;
