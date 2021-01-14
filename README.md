Marketplace is an app similar to GoFundMe and Kickstarter where users can crowdsource/fund their way to building their next big idea. Entrepreneurs/Designers/Developers can pitch their concept of an app and ask for donations to help fund their process of building it.

Core Requirements:

    A User must be logged in to manipulate any part of the platform.
    A User can have two roles (three if you count admin). A maker 
        and a backer are those roles. Backers provide funding 
        via payment forms (Stripe) to fund the Maker's venture. 
        The Maker can receive direct funding from Backers with an amount
        set aside for the app to take a cut. Any Backer can also be a Maker
        and vice versa.
    A Maker can post their project and save it as a draft or public. 
        Once public, the project can be backed by the Backer.
    A User can't back their own project directly but can edit content.
    All projects have an expiration date of 30 days.
    A Project can't be edited by a Backer unless it's their own.
    A Project can be commented on by both a Maker and a Backer.
    A Project can have perks as stacked backing amounts.
    Perks can be any number dictated by the Maker
    Each Perk represents a single transaction

Stack

    Ruby on Rails
    Stimulus JS
    Tailwind CSS

Modeling:

    User
        Roles: Admin, Maker, Backer
        Username
        Name
        Email
        Password
    Project
        Title
        Description
        Donation Goal
        Commentable Type
        Commentable ID
        User ID
    Perk - Relative to Projects but seperated
        Title
        Amount
        Description
        Amount Available
        Project ID
    Comment - Polymorphic
        Body
