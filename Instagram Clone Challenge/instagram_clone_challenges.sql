-- Find 5 oldest users.
SELECT * 
FROM users 
ORDER BY created_at
LIMIT 5

-- What day of week do most users register on?
SELECT 
	DAYOFWEEK(created_at) AS day_of_week,
	DAYNAME(created_at) AS day_name, 
    COUNT(created_at) AS users_registered 
FROM users
GROUP BY dayofweek(created_at)
ORDER BY users_registered DESC
LIMIT 2

-- Find the users who never posted a photo.
SELECT users.id, username 
FROM users
LEFT JOIN photos
ON users.id = photos.user_id
WHERE photos.id IS NULL
ORDER BY users.id

--  Identify most popular photo (and user who created it).
SELECT 
	users.id AS user_id, 
    username,photos.id AS photo_id, 
    image_url, 
    count(*) AS total_likes 
FROM photos
INNER JOIN likes
ON photos.id = likes.photo_id
INNER JOIN users
ON users.id = photos.user_id
GROUP BY photos.id
ORDER BY total_likes DESC
LIMIT 1

-- How many times does the average user post?
SELECT 
	(SELECT COUNT(image_url) FROM photos) /
    (select COUNT(id) FROM users) AS avg_posts_per_user

-- What are the top 5 most commonly used hashtags?
SELECT 
	tag_name, 
    COUNT(tag_id) AS total_tags 
FROM tags
INNER JOIN photo_tags
ON tags.id = photo_tags.tag_id
GROUP BY tag_name
ORDER BY total_tags DESC
LIMIT 5

-- Find users who have liked every single photo on the site.
select 
	username, 
    count(username) as total_likes 
from users
join likes
on users.id = likes.user_id
group by username
having total_likes = (select count(*) from photos)