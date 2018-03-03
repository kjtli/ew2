# Test data:
# - There are 4 members - member1, member2, member3, and member4
# - member1 has 3 headings - "member1 h1", "member1 h2", and "member1 h3" and no friend.
# - member2 has 1 heading - "member2 h1" and two friends - member3 and member4
# - member3 has 2 headings - "member3 h1" and "member3 h2" and a friend of member2, per requirement.
# - member4 has no headings and a friend of member2, per requirement

# Delete old data
Friend.delete_all
Heading.delete_all
Member.delete_all

# Create Members
members = [
  { name:'member1', pws_full_url:'member1-furl', pws_short_url:'member1-surl' },
  { name:'member2', pws_full_url:'member2-furl', pws_short_url:'member2-surl' },
  { name:'member3', pws_full_url:'member3-furl', pws_short_url:'member3-surl' },
  { name:'member4', pws_full_url:'member4-furl', pws_short_url:'member4-surl' }
]

members.each { |member| Member.create member }

# Create Headings
members = Member.all
member1 = members[0]
member2 = members[1]
member3 = members[2]
member4 = members[3]

# member1 has three headings
Heading.create(member: member1, content: member1.name + " h1")
Heading.create(member: member1, content: member1.name + " h2")
Heading.create(member: member1, content: member1.name + " h3")

# member2 has one heading
Heading.create(member: member2, content: member2.name + " h1")

# member3 has two headings
Heading.create(member: member3, content: member3.name + " h1")
Heading.create(member: member3, content: member3.name + " h2")

# member4 has no headings

# Create Friends

# member1 has no friends.  sad...

# member2 has member 3 and 4 as friends
Friend.create(member: member2, friend_id: member3.id)
Friend.create(member: member2, friend_id: member4.id)

# member 3 and 4 have member2 as friend per requirement
Friend.create(member: member3, friend_id: member2.id)
Friend.create(member: member4, friend_id: member2.id)

=begin

Queries for all features.  
*** Due to the time constraint, I only attempt the search feature. ***

1. The interface should list all members with their name, short url and the number of friends

SELECT m.name, m.s_url, count(f.friend_id) as "Num Of Friends"
FROM Members m
  LEFT OUTER JOIN Friends f
  ON m.id = f.member_id 
WHERE m.id = ? // ? contains current member.id

2. Viewing an actual member should display the name, website URL, shortening, website headings, 
   and links to their friends' pages. (member could have 0 to many headings and 0 to many friends)
   
SELECT m.name, m.f_url, m.s_url, h.content, f.friend_id
FROM Members m
  LEFT OUTER JOIN Headings h
  ON m.id = mh.member_id 
  LEFT OUTER JOIN Friends f
  ON m.id = f.member_id 
WHERE m.id = ?  // ? contains current member id
   
3. Now, looking at Alan's profile, I want to find experts in the application who write about a certain topic and are not already friends of Alan.

Results should show the path of introduction from Alan to the expert e.g. Alan wants to get introduced to someone who writes about 'Dog breeding'. Claudia's website has a heading tag "Dog breeding in Ukraine". Bart knows Alan and Claudia. 
An example search result would be Alan -> Bart -> Claudia ("Dog breeding in Ukraine").

Notes: After discussing with Dustin, he told me don't worry about Bart, the middle man. In other word, Alan and Claudia
do not need to have a common friend.

3.1 first query returns all headings that match search text but not owned by current member

SELECT m1.id, m1.name, h.heading
FROM Headings h
  JOIN Members m1
  ON h.member_id = m1.id
WHERE h.heading LIKE "%?%" // ? contains search text; it may need to handle SQL unsafe characters...
  AND h.member_id IN
    (SELECT m2.id
     FROM Members m2
     WHERE m2.id != ?);  // ? contains current member id
     
3.2 if experts are found, returns experts who are not friends of current member

SELECT m.name, m.id
FROM Members m
WHERE m.id IN (?, ?, ...) AND m.id NOT IN  // ? contains expert member ids from first query
(SELECT f.friend_id
FROM Friends mf
WHERE f.member_id = ?); // ? contains current member id

=end