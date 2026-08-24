<?php get_header(); ?>

<!-- Hero Image -->
<div class="hero-image-container">
    <img src="<?php echo get_template_directory_uri(); ?>/images/dshadle_facilitation.png" alt="David Shadle facilitation illustration" class="hero-image">
</div>

<!-- Content Section 01: INTRODUCTION -->
<section class="section section-introduction">
    <div class="section-container">
        <div class="two-col-layout">
            <!-- Left Column -->
            <div class="intro-left-col">
                <h1 class="intro-name">DAVID <span class="intro-name-bold">SHADLE</span></h1>
                <div class="intro-divider"></div>
                <nav class="intro-links">
                    <a href="<?php echo esc_url(home_url('/case-studies')); ?>" class="intro-link">
                        <img src="<?php echo get_template_directory_uri(); ?>/images/briefcase.png" alt="" class="intro-link-icon">
                        <span>CASE STUDIES</span>
                    </a>
                    <a href="<?php echo esc_url(home_url('/resume')); ?>" class="intro-link">
                        <img src="<?php echo get_template_directory_uri(); ?>/images/resume.png" alt="" class="intro-link-icon">
                        <span>RESUME</span>
                    </a>
                    <a href="<?php echo esc_url(home_url('/endorsements')); ?>" class="intro-link">
                        <img src="<?php echo get_template_directory_uri(); ?>/images/talk-bubble.png" alt="" class="intro-link-icon">
                        <span>ENDORSEMENTS</span>
                    </a>
                </nav>
            </div>

            <!-- Right Column -->
            <div class="intro-right-col">
                <blockquote class="intro-quote">Think of me as the person who steps in when there's a great idea but no clear path forward.</blockquote>

                <p class="intro-body">I help teams transform their products to drive revenue growth and reach product-market fit faster - re-platforming legacy systems, integrating AI capabilities that create real user value, and redesigning experiences that turn complexity into competitive advantage.</p>

                <h2 class="intro-section-header">WHY WORK WITH ME</h2>

                <p class="intro-body">Whether you need someone to lead through a transition, partner on execution, or embed with your team for sustained impact, I adapt to what the situation requires.</p>

                <p class="intro-body">You get someone who understands the business context first, then uses UX strategy and execution to deliver transformation. I audit your current experience, identify what's blocking growth, and build the roadmap that gets you there - then stay in the work to help execute it.</p>

                <p class="intro-body"><strong>The outcome:</strong> products that customers actually want to buy, experiences that reduce friction and increase conversion, and platforms built to scale without accumulating technical and design debt.</p>
            </div>
        </div>
    </div>
</section>

<!-- Content Section 02: DETAILS -->
<section class="section section-details" id="details">
    <!-- Tab Navigation -->
    <nav class="details-nav">
        <div class="details-nav-container">
            <button class="details-nav-link active" data-tab="how-i-work">HOW I WORK</button>
            <span class="nav-pipe">|</span>
            <button class="details-nav-link" data-tab="who-i-work-with">WHO I WORK BEST WITH</button>
            <span class="nav-pipe">|</span>
            <button class="details-nav-link" data-tab="services">SERVICES OFFERED</button>
            <span class="nav-pipe">|</span>
            <button class="details-nav-link" data-tab="about">ABOUT ME</button>
            <div class="nav-indicator"></div>
        </div>
    </nav>

    <!-- Details Content Area -->
    <div class="details-content-area">
        <div class="details-top-line"></div>

        <!-- How I Work Tab -->
        <div class="details-tab-content active" id="tab-how-i-work">
            <div class="section-container">
                <div class="two-col-layout details-layout">
                    <div class="details-left-col">
                        <img src="<?php echo get_template_directory_uri(); ?>/images/Index-Engagement-How.png" alt="How I Work illustration" class="details-image">
                    </div>
                    <div class="details-right-col">
                        <h2 class="details-section-header">HOW I WORK</h2>
                        <p class="details-body">I start by understanding your business context - what's working, what's not, and where the real opportunities are. Then I work alongside your team to design and execute solutions that actually stick.</p>

                        <p class="details-body">My approach combines strategic thinking with hands-on execution. I don't just deliver recommendations and walk away. I partner with you to implement changes, measure results, and iterate based on what we learn.</p>

                        <p class="details-body">Typical engagements range from focused 4-week sprints to embedded partnerships of 3-6 months. The right structure depends on your situation - we'll figure out together what makes sense.</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Who I Work Best With Tab -->
        <div class="details-tab-content" id="tab-who-i-work-with">
            <div class="section-container">
                <div class="two-col-layout details-layout">
                    <div class="details-left-col">
                        <img src="<?php echo get_template_directory_uri(); ?>/images/Index-Engagement-Who.png" alt="Who I Work With illustration" class="details-image">
                    </div>
                    <div class="details-right-col">
                        <h2 class="details-section-header">WHO I WORK BEST WITH</h2>
                        <p class="details-body">I work best with product leaders and founders who know they need to transform their user experience but don't have the bandwidth or specialized expertise in-house.</p>

                        <p class="details-body">You might be a Series A startup trying to nail product-market fit, a growth-stage company re-platforming to scale, or an enterprise team integrating AI into existing products.</p>

                        <p class="details-body">What my best clients have in common: they value speed and quality, they're ready to invest in getting it right, and they want a partner who can both think strategically and execute.</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Services Offered Tab -->
        <div class="details-tab-content" id="tab-services">
            <div class="section-container">
                <div class="two-col-layout details-layout">
                    <div class="details-left-col">
                        <img src="<?php echo get_template_directory_uri(); ?>/images/Index-Engagement-Services.png" alt="Services illustration" class="details-image">
                    </div>
                    <div class="details-right-col">
                        <h2 class="details-section-header">SERVICES OFFERED</h2>
                        <p class="details-body">UX Strategy & Product Direction - Defining what to build and why, based on user research, market analysis, and business goals.</p>

                        <p class="details-body">Experience Transformation - Redesigning complex products to reduce friction, increase adoption, and drive conversion.</p>

                        <p class="details-body">AI Integration Design - Helping teams thoughtfully integrate AI capabilities in ways that create genuine user value.</p>

                        <p class="details-body">Platform Re-architecture - Unifying fragmented experiences and modernizing legacy systems without disrupting existing users.</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- About Me Tab -->
        <div class="details-tab-content" id="tab-about">
            <div class="section-container">
                <div class="two-col-layout details-layout">
                    <div class="details-left-col">
                        <img src="<?php echo get_template_directory_uri(); ?>/images/Index-Engagement-About.png" alt="About Me illustration" class="details-image">
                    </div>
                    <div class="details-right-col">
                        <h2 class="details-section-header">ABOUT ME</h2>
                        <p class="details-body">I've spent 25 years at the intersection of product strategy and design, helping teams move from "we think this could work" to "here's what we're building and why."</p>

                        <p class="details-body">My background spans global tech companies like Microsoft and Oracle, early-stage startups, and everything in between. What ties it together is a consistent focus on the messy, high-stakes moments: when the vision exists but the path forward isn't clear, when stakeholders aren't aligned, or when a team needs structure to move with confidence.</p>

                        <p class="details-body">I bring both a strategic and hands-on perspective — comfortably facilitating executive conversations about direction in the morning and working through product details with a team in the afternoon. That range is what makes me useful at pivotal moments, whether that's defining a product strategy, preparing for a raise, or getting unstuck.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- Content Section 03: CONTACT -->
<section class="section section-contact" id="contact">
    <div class="section-container">
        <div class="two-col-layout">
            <!-- Left Column -->
            <div class="contact-left-col">
                <h2 class="contact-header">LET'S CONNECT</h2>
                <p class="contact-body">If you're considering a transformation and want a partner who stays in the work with you, let's connect. I'm genuinely excited about working with teams tackling meaningful challenges.</p>

                <p class="contact-body">No pitch. Just a straightforward conversation about what you're facing, whether I'm the right fit, and how we might work together to get you where you need to go.</p>
            </div>

            <!-- Right Column - Form -->
            <div class="contact-right-col">
                <form class="contact-form" action="<?php echo esc_url(admin_url('admin-post.php')); ?>" method="post">
                    <input type="hidden" name="action" value="submit_contact_form">
                    <?php wp_nonce_field('contact_form_nonce', 'contact_nonce'); ?>

                    <div class="form-group">
                        <label for="email" class="contact-form-label">Email address</label>
                        <input type="email" id="email" name="email" required>
                    </div>

                    <div class="form-group">
                        <label for="message" class="contact-form-label">Message</label>
                        <textarea id="message" name="message" rows="6" required></textarea>
                    </div>

                    <button type="submit" class="contact-submit-btn">SUBMIT</button>
                </form>
            </div>
        </div>
    </div>
</section>

<?php get_footer(); ?>
