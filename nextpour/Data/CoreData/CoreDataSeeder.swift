import CoreData
import Foundation

struct CoreDataSeeder {
    private static let seededKey = "nextpour_seeded_v1"

    static func seedIfNeeded(context: NSManagedObjectContext) {
        guard !UserDefaults.standard.bool(forKey: seededKey) else { return }
        seed(context: context)
        UserDefaults.standard.set(true, forKey: seededKey)
    }

    static func seed(context: NSManagedObjectContext) {
        seedUsers(context)
        seedBeverages(context)
        seedBartenders(context)
        seedBartenderClasses(context)
        seedEvents(context)
        seedVenues(context)
        seedPosts(context)
        seedNudges(context)
        seedCircles(context)
        seedCommunityMessages(context)
        seedRewards(context)
        try? context.save()
    }

    private static func seedUsers(_ ctx: NSManagedObjectContext) {
        guard let dtos = try? JSONLoader.load("users", as: [UserDTO].self) else { return }
        for dto in dtos {
            let e = NPUser(context: ctx)
            e.id = dto.id; e.name = dto.name; e.email = dto.email
            e.role = dto.role; e.avatarURL = dto.avatarURL; e.bio = dto.bio
            e.isAmbassador = dto.isAmbassador
            e.rewardPoints = Int32(dto.rewardPoints)
            e.rewardTier = dto.rewardTier
        }
    }

    private static func seedBeverages(_ ctx: NSManagedObjectContext) {
        guard let dtos = try? JSONLoader.load("beverages", as: [BeverageDTO].self) else { return }
        let enc = JSONEncoder()
        for dto in dtos {
            let e = NPBeverage(context: ctx)
            e.id = dto.id; e.name = dto.name
            e.beverageDescription = dto.description
            e.imageURL = dto.imageURL; e.category = dto.category
            e.rating = dto.rating
            e.isAmbassadorUpload = dto.isAmbassadorUpload
            e.authorId = dto.authorId
            e.ingredients = (try? String(data: enc.encode(dto.ingredients), encoding: .utf8)) ?? "[]"
            e.steps = (try? String(data: enc.encode(dto.steps), encoding: .utf8)) ?? "[]"
        }
    }

    private static func seedBartenders(_ ctx: NSManagedObjectContext) {
        guard let dtos = try? JSONLoader.load("bartenders", as: [BartenderDTO].self) else { return }
        let enc = JSONEncoder()
        for dto in dtos {
            let e = NPBartender(context: ctx)
            e.id = dto.id; e.name = dto.name
            e.rating = dto.rating; e.imageURL = dto.imageURL
            e.isVerified = dto.isVerified; e.bio = dto.bio
            e.yearsExperience = Int32(dto.yearsExperience)
            e.specialties = (try? String(data: enc.encode(dto.specialties), encoding: .utf8)) ?? "[]"
        }
    }

    private static func seedBartenderClasses(_ ctx: NSManagedObjectContext) {
        guard let dtos = try? JSONLoader.load("bartender_classes", as: [BartenderClassDTO].self) else { return }
        for dto in dtos {
            let e = NPBartenderClass(context: ctx)
            e.id = dto.id; e.title = dto.title
            e.classDesc = dto.description
            e.instructorName = dto.instructorName
            e.durationMinutes = Int32(dto.durationMinutes)
            e.isLocked = dto.isLocked
            e.attendeeCount = Int32(dto.attendeeCount)
            e.imageURL = dto.imageURL; e.category = dto.category
        }
    }

    private static func seedEvents(_ ctx: NSManagedObjectContext) {
        guard let dtos = try? JSONLoader.load("events", as: [EventDTO].self) else { return }
        let fmt = ISO8601DateFormatter()
        for dto in dtos {
            let e = NPEvent(context: ctx)
            e.id = dto.id; e.title = dto.title
            e.eventDescription = dto.description
            e.venueName = dto.venueName; e.venueAddress = dto.venueAddress
            e.date = fmt.date(from: dto.date) ?? Date()
            e.imageURL = dto.imageURL; e.category = dto.category
            e.attendeeCount = Int32(dto.attendeeCount)
            e.isFeatured = dto.isFeatured
        }
    }

    private static func seedVenues(_ ctx: NSManagedObjectContext) {
        guard let dtos = try? JSONLoader.load("venues", as: [VenueDTO].self) else { return }
        for dto in dtos {
            let e = NPVenue(context: ctx)
            e.id = dto.id; e.name = dto.name
            e.address = dto.address; e.imageURL = dto.imageURL
            e.rating = dto.rating; e.category = dto.category
            e.distanceMiles = dto.distanceMiles; e.isOpen = dto.isOpen
        }
    }

    private static func seedPosts(_ ctx: NSManagedObjectContext) {
        guard let dtos = try? JSONLoader.load("posts", as: [PostDTO].self) else { return }
        let fmt = ISO8601DateFormatter()
        for dto in dtos {
            let e = NPPost(context: ctx)
            e.id = dto.id; e.authorId = dto.authorId
            e.authorName = dto.authorName
            e.authorAvatarURL = dto.authorAvatarURL
            e.content = dto.content; e.imageURL = dto.imageURL
            e.likeCount = Int32(dto.likeCount)
            e.commentCount = Int32(dto.commentCount)
            e.timestamp = fmt.date(from: dto.timestamp) ?? Date()
            e.drinkTag = dto.drinkTag; e.isLiked = dto.isLiked
        }
    }

    private static func seedNudges(_ ctx: NSManagedObjectContext) {
        guard let dtos = try? JSONLoader.load("nudges", as: [NudgeDTO].self) else { return }
        let fmt = ISO8601DateFormatter()
        let enc = JSONEncoder()
        for dto in dtos {
            let e = NPNudge(context: ctx)
            e.id = dto.id; e.question = dto.question
            e.expiresAt = fmt.date(from: dto.expiresAt) ?? Date()
            e.optionsJSON = (try? String(data: enc.encode(dto.options), encoding: .utf8)) ?? "[]"
        }
    }

    private static func seedCircles(_ ctx: NSManagedObjectContext) {
        guard let dtos = try? JSONLoader.load("circles", as: [PourCircleDTO].self) else { return }
        let fmt = ISO8601DateFormatter()
        for dto in dtos {
            let e = NPPourCircle(context: ctx)
            e.id = dto.id; e.name = dto.name
            e.circleDescription = dto.description
            e.memberCount = Int32(dto.memberCount)
            e.imageURL = dto.imageURL
            e.lastActivity = fmt.date(from: dto.lastActivity) ?? Date()
            e.isMember = dto.isMember
        }
    }

    private static func seedCommunityMessages(_ ctx: NSManagedObjectContext) {
        guard let dtos = try? JSONLoader.load("community_messages", as: [CommunityMessageDTO].self) else { return }
        let fmt = ISO8601DateFormatter()
        for dto in dtos {
            let e = NPCommunityMessage(context: ctx)
            e.id = dto.id; e.senderId = dto.senderId
            e.senderName = dto.senderName
            e.senderAvatarURL = dto.senderAvatarURL
            e.content = dto.content
            e.timestamp = fmt.date(from: dto.timestamp) ?? Date()
            e.eventId = dto.eventId
        }
    }

    private static func seedRewards(_ ctx: NSManagedObjectContext) {
        let userConfigs: [(id: String, userId: String, range: ClosedRange<Int>)] = [
            ("r_u1", "u1", 30...2800),
            ("r_u2", "u2", 80...1499),
            ("r_u5", "u5", 10...499)
        ]

        let activityPool: [(desc: String, lo: Int, hi: Int)] = [
            ("Recipe upload bonus",      100, 200),
            ("Event attendance",          75, 150),
            ("Share reward",              25,  75),
            ("Circle activity bonus",     40, 100),
            ("Bartender class attended",  80, 160),
            ("Community post",            20,  60),
            ("Venue check-in",            30,  80),
            ("First recipe save",         25,  50),
            ("Referral bonus",           100, 200),
            ("Weekly streak bonus",       50, 100),
            ("Reviewed a venue",          15,  40),
            ("Shared an event link",      10,  30),
            ("Joined a Pour Circle",      30,  60),
            ("Completed a pour journey",  50, 120)
        ]

        let fmt  = ISO8601DateFormatter()
        let enc  = JSONEncoder()
        let cal  = Calendar.current
        let now  = Date()

        for cfg in userConfigs {
            let points = Int.random(in: cfg.range)
            let tier: String
            switch points {
            case 1500...: tier = "gold"
            case 500...:  tier = "silver"
            default:      tier = "bronze"
            }

            let txCount  = Int.random(in: 3...min(7, activityPool.count))
            let pool     = activityPool.shuffled()
            var history  = [RewardTransactionDTO]()

            for i in 0..<txCount {
                let a      = pool[i]
                let pts    = Int.random(in: a.lo...a.hi)
                let days   = Int.random(in: 1...90)
                let date   = cal.date(byAdding: .day, value: -days, to: now) ?? now
                history.append(RewardTransactionDTO(
                    id:          "rt_\(cfg.userId)_\(i)",
                    description: a.desc,
                    points:      pts,
                    date:        fmt.string(from: date)
                ))
            }
            history.sort { $0.date > $1.date }

            let e         = NPReward(context: ctx)
            e.id          = cfg.id
            e.userId      = cfg.userId
            e.tier        = tier
            e.points      = Int32(points)
            e.historyJSON = (try? String(data: enc.encode(history), encoding: .utf8)) ?? "[]"

            // keep NPUser in sync so rewardPoints/rewardTier stay consistent
            let req = NSFetchRequest<NPUser>(entityName: "NPUser")
            req.predicate = NSPredicate(format: "id == %@", cfg.userId)
            if let user = (try? ctx.fetch(req))?.first {
                user.rewardPoints = Int32(points)
                user.rewardTier   = tier
            }
        }
    }
}
