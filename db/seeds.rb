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
  { name:'Alan', pws_full_url:'Alan Full URL', pws_short_url:'Alan Short URL' },
  { name:'Claudia', pws_full_url:'Claudia Full URL', pws_short_url:'Claudia Short URL' },
  { name:'Mary', pws_full_url:'Mary Full URL', pws_short_url:'Mary Short URL' },
  { name:'James', pws_full_url:'James Full URL', pws_short_url:'Jame Short URL' }
]

members.each { |member| Member.create member }

# Create Headings
members = Member.all
member1 = members[0]
member2 = members[1]
member3 = members[2]
member4 = members[3]

# Alan has three headings
Heading.create(member: member1, content: "Road biking")
Heading.create(member: member1, content: "Tramping")
Heading.create(member: member1, content: "Scuba diving")

# Claudia has one heading
Heading.create(member: member2, content: "Dog breeding in Ukraine")

# Mary has two headings
Heading.create(member: member3, content: "Dog walking in Austin")
Heading.create(member: member3, content: "Climbing Mt. Cook")

# James has no headings

# Create Friends

# Alan has no friends.  sad...

# Claudia has Mary and James as friends
Friend.create(member: member2, friend_id: member3.id)
Friend.create(member: member2, friend_id: member4.id)

# Mary and James have Claudia as friend, per requirement
Friend.create(member: member3, friend_id: member2.id)
Friend.create(member: member4, friend_id: member2.id)