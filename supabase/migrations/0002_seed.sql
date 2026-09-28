-- =============================================================================
-- 0002: the site's initial content (carried over from julistanley.com and
-- updated from the July 2025 CV).
--
-- Run once in the Supabase dashboard, after 0001_init.sql. After this, the
-- database is the source of truth: edit at /admin/ on the site, not here.
-- =============================================================================

insert into public.entries
  (kind, slug, title, description, date, nav_order, published, body)
values
  ('page'::public.entry_kind, 'about', 'about', '', null, 1, true, $md$<img class="portrait" src="/assets/img/prof_pic.jpg" alt="Juliana Stanley">

julianst[at]mit[dot]edu · [eight-five-eight]837-0221 · Boston, MA

**Brief CV**

- 2020–present: PhD Student (Department of Biology), Massachusetts Institute of Technology.
  - [Gene-Wei Li lab](http://gwli.scripts.mit.edu/group/). Currently characterizing mechanisms of leaderless mRNA translation in bacteria.
- 2018–2020: MS Bioinformatics, Northeastern University.
  - Research with [Pam Silver's lab](https://silver.med.harvard.edu/) in the Department of Systems Biology at Harvard Medical School.
- 2015–2019: BS Biology, Northeastern University.
  - 2015–2019: Thesis with [Javier Apfeld's lab](https://apfeldlab.mystrikingly.com/).
  - 2017–2018: Research Assistant at [Cygnal Therapeutics](https://www.cygnaltx.com).

[Full CV (PDF)](/assets/files/CV.pdf)

My research interests are still developing. Generally, I'm interested in building models for how microorganisms adapt to different environments.

I think that research should be entirely reproducible. So, I am trying to hold myself accountable by having detailed methods for every paper that I write. Additionally, I also try to have a GitHub repository for each project for additional resources and source code.

If you would like to reach me, feel free to just shoot an email. Alternatively, you can just text me at the number listed above--don't be shy!

[email](mailto:%6A%75%6C%69%61%6E%73%74@%6D%69%74.%65%64%75) · [ORCID](https://orcid.org/0000-0002-9193-3791) · [Google Scholar](https://scholar.google.com/citations?user=N0D7hFYAAAAJ) · [GitHub](https://github.com/julistanley) · [LinkedIn](https://www.linkedin.com/in/julianstanley) · [Twitter](https://twitter.com/julianstanley_)
$md$),
  ('page'::public.entry_kind, 'blog', 'blog', '', null, 2, true, $md$Articles, opinions, and (hopefully) helpful guides.
$md$),
  ('page'::public.entry_kind, 'publications', 'publications', 'Peer-reviewed papers and pre-prints with additional information.', null, 3, true, $md$See [Google Scholar](https://scholar.google.com/citations?user=N0D7hFYAAAAJ) for a full list of publications. Google doesn't always index things correctly, so my [ORCID](https://orcid.org/0000-0002-9193-3791) can be more reliable.

I previously published under the name Julian A. Stanley; my ORCID lists all published aliases.

#### 2024

- Yang, K. & **Stanley, J.** Predicting smoking status based on RNA sequencing data. Journal of Emerging Investigators 7 (2024). [Open Access](https://doi.org/10.59720/23-099). A teaching-related publication with my Polygence mentee, Kevin Yang.

#### 2022

- Herzel, L., **Stanley, J. A.**, Yao, C.-C. & Li, G.-W. Ubiquitous mRNA decay fragments in *E. coli* redefine the functional transcriptome. Nucleic Acids Research 50, 5029–5046 (2022). [Open Access](https://doi.org/10.1093/nar/gkac295)

#### 2020

- **Stanley, J. A.**, Johnsen, S. B. & Apfeld, J. The SensorOverlord predicts the accuracy of measurements with ratiometric biosensors. Sci Rep 10, 16843 (2020). [Open Access](https://www.nature.com/articles/s41598-020-73987-0) \| [Supplement](https://uploads.strikinglycdn.com/files/99afd93f-4c35-47a5-8b31-520f483eb08a/Stanley2020supplement.pdf) \| [Code](https://github.com/apfeldlab/sensoroverlord) \| [Website](https://sensoroverlord.org/)

- Schiffer, J. A. et al. Caenorhabditis elegans processes sensory information to choose between freeloading and self-defense strategies. eLife 9, e56186 (2020). [Open Access](https://elifesciences.org/articles/56186)

- Chang, R. L., **Stanley, J. A.** et al. Protein structure, amino acid composition and sequence determine proteome vulnerability to oxidation‐induced damage. EMBO J 39, (2020). [Open Access](https://www.embopress.org/doi/full/10.15252/embj.2020104523) \| [Code](https://github.com/julianstanley/ProteinFeatures) \| [Extra Documentation](https://julianstanley.github.io/ProteinFeatures/docs/public/intro_public.html)

#### 2019

- de la Parra, J., **Stanley, J.**, Foster, S., Webb, C. & Lykourinou, V. Crafting A More Environmentally Benign Extraction and Analysis of Pharmaceutical Precursors from a Medicinal Plant: A Student-Led Innovation. chemRxiv (2019). [Open Access](https://doi.org/10.26434/chemrxiv.7791716.v1)

#### Patents

From my time at Cygnal Therapeutics (Kahvejian et al.):

- Methods and Compositions for Treating Inflammatory or Autoimmune Diseases or Conditions Using Serotonin Receptor Activators. [US11208475B1](https://patents.google.com/patent/US11208475B1) (2021).
- Methods and Compositions for Treating Inflammatory or Autoimmune Diseases or Conditions Using GRM8 Activators. [US11059886B1](https://patents.google.com/patent/US11059886B1) (2021).
- Methods and Compositions for Treating Cancer Using Serotonin Receptor Inhibitors. [US11034751B1](https://patents.google.com/patent/US11034751B1) (2021).
- Methods for Treating Cancer Using GRM8 Inhibitors. [US10683352B1](https://patents.google.com/patent/US10683352B1) (2020).
$md$),
  ('page'::public.entry_kind, 'teaching', 'teaching', 'Classes I''ve contributed to.', null, 4, true, $md$## Spring 2024

### Quantitative Analysis of Biological Data / Quantitative Measurements and Modelling of Biological Systems (7.571/7.572)

I was a graduate TA for this two-part graduate quantitative biology course, where I led twice-weekly discussion and problem-solving recitations and graded. You can find my [full course evaluation here](/assets/files/evaluations_spring2024_7572.pdf).

## Spring 2022 - Fall 2023

No teaching during this period, besides mentoring in the lab.

## Fall 2021

### Introductory Biology (7.015)

I was one of three TAs for an introductory biology course, where I was in charge of one of three recitation sections that met twice-per-week.

I really enjoyed designing content for my recitations and leading discussions. While we were given papers and problems to discuss during recitations, the course instructor (Dr. Moni Avello) was fantastic about giving TAs lots of autonomy over recitation sections, and helping us learn to write good pset and exam questions.

I thrive on positive feedback and was happy have high evaluations for this course. You can find my [full course evaluation here](/assets/files/evaluations_fall2021_7015.pdf). Four students left comments:

* Student 2655 - Extremely thoughtful and supportive. Super positive learning experience!
* Student 15451 - I found these recitations to be incredibly helpful. He always made sure we were prepared for psets and exams and was always willing to answer questions.
* Student 28946 - Wonderful teacher, did a great job of explaining questions and telling us what we needed to knwo to perform well in the class.
* Student 47110 - Thanks for being an awesome TA - you carried me through this class and were super helping in answering all of my questions.

Our TA training coordinator, Dr. Summer Morill, recorded one of my recitation sessions to use for future TA training. There are three parts of the recitation, which I've uploaded as unlisted youtube videos here:

* [Part 1](https://youtu.be/Q_gk6sgfRgY)
* [Part 2](https://youtu.be/zrViY6luIr0)
* [Part 3](https://youtu.be/euh3gPq_yDY)

## Fall 2020 - Summer 2021

No teaching during this period while completed PhD coursework and rotations.

## Summer 2020

### Molecular Biology: DNA Replication & Repair (7.28.1x-7.28.3x)

This was an online, community TA position for MITxbio. I had a great time teaching (and learning among) students from all over the world in the discussion forums.

## Spring 2020

### Bioinformatics Computational Methods 2 (BINF6309)

This was a TA position for a core graduate bioinformatics class. I managed the online materials (deploying through GitHub and GitBook) and wrote a few dozen pages of materials about basic bioinformatics algorithms. I was also invited to give a guest lecture on clustering and distance metrics (unexpectedly, my lecture was the last in-person lecture before we went virtual due to the COVID-19 pandemic).

## Fall 2019

### Bioinformatics Computational Methods 1 (BINF6308)

This was a TA position for a core graduate bioinformatics class. I helped Dr. Chuck Roesel transition the curriculum onto a online textbook hosted on GitBook.

## Spring 2017-Summer 2019

No teaching during this period while I focused on my undergraduate thesis in the Apfeld Lab.

## Fall 2016

### Laboratory for Genetics and Molecular Biology (BIOL2302, Northeastern University)

This was a curriculum development project. I wrote some modules with background, exercises, etc. for Northeastern's undergraduate genetics lab.

## Summer 2016

### Techniques in Biology (BIOL2309, Northeastern University)

This was a teaching-assistant (TA) position for a small (~12) laboratory course. I think the course is now called Biology Project Laboratory. It was super practical, teaching to pipette, do PCR, etc. I also got to help students develop independent mini-projects.

## Spring 2016

### Laboratory for General Chemistry I (CHEM 1217, Northeastern University)

This was a curriculum development project. It was a lot of fun, I was part of a small team that re-developed our introductory chemistry lab to be project-oriented and incorporate elements from research being conducted on-campus.

## Service & mentorship

- **MIT Quantitative Methods Workshop** (2023, 2025) — instructor for a 4-hour quantitative RNA sequencing workshop for undergraduates with limited access to research experience at their home institution.
- **Polygence** (2022–2023) — bioinformatics project mentor, guiding high school students in independent research projects with clearly defined checkpoints and goals.
- **MIT Biology Application Assistance Program (BAAP)** (2021–2024) — founded BAAP to support students applying to biology PhD programs. Helped to organize panels, mentor pairings, and information sessions with 50+ graduate students and 100+ applicants, then facilitated a smooth transition of program leadership to earlier-stage graduate students.
- **Científico Latino** (2020, 2021) — mentor to PhD applicants from backgrounds historically underrepresented in biology.
- **CovEducation** (2020, 2021) — mentored a high school student in history, chemistry, computer science, and college preparation from the start of the COVID-19 pandemic until they entered college.
- **Boston Public Schools Science Fair** (2020–2022) — science fair judge for Region V and VI middle and high school students in biology and computer science.
$md$),
  ('page'::public.entry_kind, 'news', 'news', '', null, null, true, $md$$md$),
  ('post'::public.entry_kind, 'prelim', 'How to Study for a Preliminary Exam', 'PhD Preliminary Exam Studying', '2022-08-01', null, true, $md$How do you study for a preliminary exam? I don't know, I was hoping you could tell me.

**Table of Contents:**
* [Set some goals](#step-1-setting-goals-to-stay-focused-and-motivated)
* [Personal study notes](#study-notes)

I might write something insightful up here at some point. For now, just trying to make a daily log of what I've been doing. 



# Step 1: Setting goals to stay focused and motivated

It seems like common knowledge that it's important to have goals, but I often overlook them when starting a project.

My goal with my preliminary exam _isn't_ just to pass the exam, which 


# Study Notes

## Timeline

If I'm going to make progress, I need deadlines. All my deadlines are going to be for 4PM EST.

Tuesday, August 9 (5 weeks): Rough draft of slides and presentation
Tuesday, August 16 (4 weeks): Schedule practice prelims for next week
Tuesday, August 23 (3 weeks): 
Monday, September 12 (1 day): No more preparation

## Aims


## Techniques Log

### Flow cytometry

### RNA sequencing 

### Northern blot

### Pulse-Chase

For example, we want to see whether mazF inhibits ribosome formation. So, pulse 3H-Uridine and chase with cold uridine, run a polysome gradient and you can see that 3H-uridine is incorporated into ribosomes in absense of mazF, but not after expression of mazF. 

## Papers to-read

This section will eventually go-away, as I read these papers and put summaries in the daily logs.

[Hockenberry 2018](https://doi.org/10.1093/molbev/msx310) for some hypotheses about why translation initiation varies.

[Giess 2017](https://bmcbiol.biomedcentral.com/articles/10.1186/s12915-017-0416-0) for another method that may help identifying translation start sites. 

### Why is initiation important?

[Hersch 2014](https://www.sciencedirect.com/science/article/pii/S0021925820370770) can affect stalling.

### Does CDS Sequence matter?

[Verma 2019](https://www.nature.com/articles/s41467-019-13810-1) early elongation events matter for efficiency.

### How does rRNA maturation work?


## Daily Log

### Wednesday, 3 August 2022

#### Reading(s) for today:

#### 1. [Wade 2019, mBio](https://journals.asm.org/doi/10.1128/mBio.00825-19)

**Summmary:** This is a letter in response to Nigam 2019, about the generation of proteins after mazF toxin induction by nalidixic acid (NA). 

In the 42 genes identified by Nigam 2019, none have more ACA upstream of the start codon than in the set of all E. coli genes. For some of these genes, ACAs identified by Nigam are not in the mRNAs at all. 

Nigam sees GFP changes upon NA treatment, and Wade & Laub argue that this is probably a non-mazF-dependent effect, especially since many of the identified genes are known to be stress-responsive genes. 

##### 2. [Nigam 2019, mBio](https://journals.asm.org/doi/10.1128/mBio.01063-19)

**Summary:** This is Nigam et al.'s reply to Wade & Laub's critique above. They say that they don't claim that ACA is enriched before the start codon in these genes. They claim that the stress transcription factor σ<sup>32</sup> is a result of modified ribosomes. 

I'm not convinced by this response, so I'm not going to go further on the original paper--I think they're detecting upregulation of a general stress response.

## Tuesday, 2 August 2022

### Progress for today

Not much progress outside of reading today.

### Reading(s) for today:

#### 1. [Oron-Gottesman 2016, mBio](https://doi.org/10.1128/mBio.01855-16)

**Summary:** Used a fluorescent reporter +/- ACA sequences with induction of mazF with nalidixic acid to show some sequence dependencies of mazF.

**Relevance to project:** They have a leaderless construct, but not very relevant. Maybe worth looking at the EDF-like sequence in S1 for lmRNA expression?

A leaderless GFP mRNA, has 17 out-of-frame ACA sites that don't interfere with expression after mazF induction. Adding an ACA site in the ORF prevented expression. 

Really not impressed by the quality control in this paper. E.g., it sites Fig S1 about the effect of nalidixic acid on their reporter, but S1 has nothing to do with nalidixic acid--that's S2. & Their "OD600" axis is in the hundreds--is it OD * 100?

Basically we're seeing that induction of mazF _reduces_ the GFP level in constructs with in-frame ACA sites. There's no difference in a mazEF knockout, and it _increases_ GFP level in WT and when you add an AC before the start codon (they call this leaderless due to cleavage, but don't show that). 

They make an argument that only in-frame ACA sites are cleaved, substantiating their claim by comparing PCR band intensities. 

Then they find that their GFP-up/down phenotype +/- mazF induction can be reserved by making a mutation to the EDF-like sequence in bS1.

They conclude that there may be a bias away from ACAs being in frame, to protect from mazF cleavage. 

I'm not convinced by this paper--the figures are not very clean, there are not multiple veins of evidence for each conclusion. It highlights that I really need to make sure I can think critically about the techniques raised in the controversy over the formation of stress-induced translation machinery, should also read [Wade 2019](https://journals.asm.org/doi/10.1128/mBio.00825-19) and the response [Nigam 2019](https://journals.asm.org/doi/10.1128/mBio.01063-19) and [Vesper 2011](https://pubmed.ncbi.nlm.nih.gov/21944167/), and [Culviner 2018](https://www.sciencedirect.com/science/article/pii/S1097276518303484).

#### 2. [Culviner 2018](https://www.sciencedirect.com/science/article/pii/S1097276518303484)

**Summary:** Used high-throughput RNA sequencing and ribosome profiling to carefully quantify mazF products. Leaderless RNAs aren't upregulated in mazF stress. 

**Relevance to project:** The Moll lab has argued that mazF creates lots of lmRNAs and specalized ribosomes. This paper shows that that's not the case. How do we explain results from Moll and colleagues? 

Take a ΔmazF strain, put mazF on an ara-inducible promoter, low-copy plasmid. Induce mazF for just 5 minutes, take paired-end sequencing reads, and look for regions where density decreases. Confirm patterns with single-gene RT-qPCR. 

82% of genes were highly-cleaved (2-fold or more downregulated, compared to empty vector) after mazF induction. 

They also compare this to 5'-OH sequencing, but that's not well-correlated--likely because of different 5'-end stabilities. 

Not all ACAs are cleaved at the same rate, so they took some sequence logos and think that there's a ~7-nt region. 

They confirmed that these flanking sequences are important by selecting some of them across different RNA-seq scores, taking them out of context into a reporter, and then qPCR quantifying them, and that correlated as-expected.

They find a few genes that, by this method, may be leaderless after mazF induction (just 41). They measure ribosome footprints for all genes, and find that none of those leaderless genes have any substantial increase in footprints. 

To put the nail in the coffin, they added an ACA site between the RBS and start codon of YFP, and did not see any increase in flourescence after mazF induction.

They also saw traffic jams of ribosomes upstream of identified cleavage sites. 

As far as specalized ribosomes: they see clear cleavage products at the ACA sequences in nascent 16S rRNA sequences, which inhibits rRNA maturation. They pulse-chased hot uridine 


### Monday, 1 August 2022

I want to focus on a few things over the course of this study period:

* Write my project proposal
* Better understand and revise my project proposal
* Map between my proposal and common techniques / ways of thinking from 1st year course material
* Record my progress each day 


#### Progress for today:

1. Start to write a messy version of the preliminary exam proposal
   1. Not much progress here, just got the header/abstract done

#### Reading(s) for today:

1. [Nikolic 2022, BMC Research Notes](https://link.springer.com/article/10.1186/s13104-022-06061-9)

**Summary:** Used a fluorescent reporter +/- ACA sequences and +/- a leader under expression of mazF. 

**Relevance to project:** They use a "leaderless" construct, but they don't specify the promoter (native GFP promoter?) or show a 5' start, but that may have been shown in reference paper (Oron-Gottesman 2016, will read next). In both plasmids, they are not able to see expression of leaderless GFP over background, except in the high-copy-number-plasmid after 6h mazF induction. So, their lmRNA GFP is not highly expressed.

**Relevant data points:**

1. Their "leaderless" GFP is expressed at the same level as no-reporter, whereas canonical GFP is ~40-fold in exponential phase. 

**Figure summary:**

Figure 1 shows GFP (under leaderless or canonical mRNA, both without ACA sequences) after induction of mazF. In a high copy plasmid, there's clear increase in GFP concentration compared to no-plasmid control. 

Figure 2 shows that the amount of increase of flourescence after mazF induction is lower for mCherry (with ACA) than GFP (without ACA)
$md$),
  ('post'::public.entry_kind, 'shinyigv', 'shinyIGV Example', 'Documenting an attempt at using shinyIGV', '2022-03-25', null, true, $md$## Goals 

### Introducing Rend-Seq data
The Li Lab generates end-enriched RNA sequencing (Rend-Seq) data that looks something like this:

<img width="1345" alt="image" src="https://user-images.githubusercontent.com/22749289/160170871-f560c50b-d403-4225-a63c-357a3b5ac225.png">

In the bottom pane, we can see the _mrp_ is a gene on the minus (reverse) strand of the _E. coli_ genome and _metG_ is a gene on the plus (forward) strand of the genome.

The top pane shows end-enriched reads from the plus strand and the middle pane shows reads from the minus strand. 5' (often transcription start) peaks are in blue, and 3' (often transcription stop) peaks are in red. So, for example, we can see that _metG_ has strong 3' peak at the end of the transcript, but not as strong of a 5' peak. In contrast, _mrp_ has approximately equally-strong 5' and 3' peaks.

### Peak Calling

#### Introduction

By eye, it is easy to see end-enriched peaks in the data above. Our eyes are fairly adept at spotting peaks, but it can be a time-consuming process to annotate all peaks in the genome (Li Lab member Mandy Levine did just this with the small T4 genome and it took hundreds of hours).

For example, take a look at this genomic region:

<img width="543" alt="image" src="https://user-images.githubusercontent.com/22749289/160172166-3409d066-5c9b-49ab-bd03-710c894d7d3b.png">

It's relatively easy to see real peaks between the thiM and rcnR gene bodies. However, the signals that we see through the thiM gene body don't seem biological: those are probably sequencing artificats. Computationally, it might not be trivial to distinguish between these two. 

#### Implementation

TODO
$md$),
  ('post'::public.entry_kind, 'sensoroverlord_reviews', 'Peer Review: SensorOverlord Paper', 'My first long journey, summarized', '2020-05-20', null, true, $md$For years on Twitter, I've seen scientists in different degrees of celebration or dismay that correspond to different stages of the peer review process. 

It's interesting being a student in this environment. I'm probably part of the first generation of students to see some of the inner-workings of the scientific community before really being a part of it. If I was a student in the 80s, I might've been well into my PhD before being privy to professorly complaints about the peer review process.

So, when I finally finished the year-long process of writing my first primary-author paper (after hundreds of drafts, slowly improved by edits from anyone who was willing to give them), I had some vague sense of what lie ahead.

About seven months later--a year and a half or so after my first draft--I finally have my first publication. I often have to qualify that it's *just* in Scientific Reports, just barely a " real" journal, but I'm still proud that it's out. 

Below is the timeline for my peer review process. I don't know why exactly I'm documenting it. To remind myself? To help others that come after me better prepare for the process? I'm not sure, but here it is.


## Step 1: The preprint

My advisor, Javier, put the paper on [biorxiv, here](https://www.biorxiv.org/content/10.1101/2020.01.31.928895v1). That was a very easy process. We celebrated. 

## Step 2: Desk-rejections

We submitted to Nature Methods on 10 February, 2020. It was rejected on 12 February. That was a bummer, we thought it was a good fit. But fast rejections are good.

Then we submitted to PLOS Biology later that day--12 February, 2020. Desk rejection five days later, 17 February.


## Step 3: Major Revisions :/

I suggested BMC Biology next. We submitted on 18 February, 2020.

We passed the editor's desk (woo!!)

Then, three long months later (19 May, 2020), an email:

<blockquote> Please accept my apologies for this prolonged review process. </blockquote>

Oh, was it prolonged? I definitely wasn't refreshing my email every five minutes. (But actually no worries--finding reviewers seems like a damn hard job).

> You will see that while the reviewers comment on the interest of the study, they have raised significant issues, [...] It might be more productive to submit the manuscript to another journal, however, if you can address the criticisms, which as we see it will require further experiments, we should be happy to see a resubmission.

Ahh, bummer. Here are some snippets from those reviews:

Reviewer \#1 was the big bummer. They said:

> I personally enjoyed to read the manuscript. However, overall, it is too immature to publish in BMC biology.

And they wanted more experiments:

> The authors should pick up two or three probes, and investigate the same correlations to ones shown in Fig 1, with adding the various artificial error.

This would be a decent undertaking, maybe a few months of work. Combined with the other suggestions, Javier thought it would be about a year of work. And we didn't think it was necessary: I presented a mathematically-rigorous model that was guaranteed to work under my assumptions. 

Ultimately, I interpreted this reviewer's reaction as a failure on my part to properly communicate the significance of my findings. Javier didn't think so, though--he just thought it was a luck of the draw.. 

And Reviewer \#2 was very positive:

> Overall I think the experiments are well executed and controlled, and the manuscript is well written. I am therefore in favor of the publication of the manuscript on BMC Biology, provided that following minor questions can be addressed satisfactorily. 

And what followed were reasonable, but definitely seemed like that reviewer didn't fully understand some of our figures. 

## Step 4: Out-of-scope desk rejection.

On May 20, Javier suggested submitting to Genetics. They quickly came back on May 22nd and told us that they couldn't find a suitable editor to review our paper. 

## Step 5: Minor revisions!!

Finally, we decided to submit to the mega-est of megajournals: Scientific Reports. That was on May 22nd.

On June 6th, we got a confirmation that it was out for review.

Two months later--August 5th, 2020, we received a set of reviewer comments. And they were pretty positive! Just two reviews. 

The first review said:

> This manuscript is quite suitable for publication in this journal. Some minor questions might be addressed in the revision:

Their questions were

(1) about microscopes that set their own algorithms for output ratios. We turn off any microscope processing. We like to record raw intensities and do any processing afterwards--so we recommended that people do the same. We also explained some about our post-processing, and why it doesn't affect the model.

(2) About how fluorophores work differently in different environments.
This was a really good point, which we addressed some in the paper. In some cases, we can address that. In other cases, we can't. 

The second review said:

> I would suggest a major revision by considering the following points:

But the actual points were super minor. Things like asking us to make more simplifications to our formulas and talking about how background reduction affects our results. 

After getting these reviews, I worked 8+ hours on revisions each day, while doing other work. It was exhausting. Javier submitted the response to reviewers on August 11th. 

Then we got the acceptance on September 24th, and proofs near-after (September 28th). And that was that!

On October 13th, Javier received an email from a PI in France who said:

> [...] we chatted a bit some days ago on your brand new paper concerning SensorOverlord. I read it yesterday, and it is brilliant!

That made me really happy. I need to remember to email authors when I like their papers.
$md$),
  ('post'::public.entry_kind, 'ubuntussd', 'SSD Formatting and Install in Ubuntu 19.04', '', '2019-05-05', null, true, $md$Today I upgraded the base 256 GB SSD (2.5 mm) on my Thinkpad T460 to a 1 TB [Samsung 860 EVO](https://www.amazon.com/gp/product/B078DPCY3T/ref=ppx_yo_dt_b_asin_title_o00_s00?ie=UTF8&psc=1).

It took me a few google searches to learn how to make the transition. In the end, I used Tuxboot to make a bootable Clonezilla USB drive, and then GParted to resize my partition. Here's what I did step-by-step:

0. Connect your new SSD via USB. I used [a StarTech cable from Amazon](https://www.amazon.com/gp/product/B00HJZJI84/ref=ppx_yo_dt_b_asin_title_o00_s00?ie=UTF8&psc=1). 
1. Download Tuxboot (from the [SourceForce Repo](https://sourceforge.net/projects/tuxboot/files/)).
2. Extract and install Tuxboot.
    * I needed to run `apt-get install libqt4-dev`, `apt-get install mtools`, and then `./INSTALL`.
3. Run `sudo ./tuxboot` to run the tuxboot GUI. On the first line, select "On-Line Distribution" and "clonezilla_live_stable", connect an empty USB drive, select that drive on the last line, and click "OK".
4. After tuxboot makes a bootable clonezilla USB, boot from that USB.
5. Follow the disk-to-disk clone tutorial from on the [Clonezilla website](https://clonezilla.org/show-live-doc-content.php?topic=clonezilla-live/doc/03_Disk_to_disk_clone).
6. After restarting, download Gparted with `sudo apt-get gparted`. Follow the instructions in the GUI to resize the new disk to the full ~950 GB. 
7. Physically install the new SSD, and you should be good to go!
$md$),
  ('post'::public.entry_kind, 'mongo_rshiny', 'Connecting a remote MongoDB database with R/Shiny', '', '2019-04-24', null, true, $md$While making a Shiny App for a lab project (Sensor Overlord), I wanted to create 
a feature where users could input sensor data into a database, where it could
be accessible to other users. 

I decided to give MongoDB a shot, mostly becuase of the free hosting services
available on [MongoDB's website](https://mongodb.com). 

And it was actually extremely straightforward. There are great resources 
available online, like 
[the mongolite user manual](https://jeroen.github.io/mongolite/) and the
[shiny persistent data storage page](https://shiny.rstudio.com/articles/persistent-data-storage.html).

But it still took some troubleshooting on my part, so I wanted to share
my mongodb.com-specific guide.


# MongoDB.com free cluster setup and configuration 

1. Create an account on cloud.mongodb.com.
2. Set up a basic (free) cluster, give it a name. I named mine SensorOverlordCluster.
3. On the main cluster page, navigate to the "Security" tab and add a user.
    * I'll give mine the username *myself* and the password *letmein*.
4. Back on the "Overview" tab, click the name of your cluster. 
5. In the new screen that appears, click the "Collections" tab.
6. Create a new database and write down the database and collection name.
For mine, the database name was *sensordb* and the collection name was *responses*.

# Writing and reading MongoDB from R

1. Install the mongolite package
     * I'm running Ubuntu and had to run 
     `sudo apt-get install libssl-dev libsasl2-dev` to get the dependencies I 
     needed for my system. See the 
     [the mongolite user manual](https://jeroen.github.io/mongolite/) for 
     more info specific to your system.
     * `install.packages("mongolite")` for the CRAN version or `devtools::install_
     github("jeroen/mongolite")` for the development version.
2. Save some data to your database. I'll put the code below.
    * Note that the host should me mnopd.mongodb.net if you're using mongodb.net's
    hosting service. If that doesn't work, check the base url that's given when
    you click "connect" on the main overviewpage on cloud.mongodb.com,
    and then click "Connect Your Application" and set your driver as C
    version 1.9 or later. Your eventual url input should mimic that
    "connection string only" field.
    
```{r}
options(mongodb = list(
    "cluster" = "sensoroverlordcluster",
    "host" = "mnopd.mongodb.net",
    "username" = "myself",
    "password" = "letmein"
))

databaseName <- "sensordb"
collectionName <- "responses"

saveData <- function(data) {
    # Connect to the database
    db <- mongo(collection = collectionName,
                url = sprintf(
                    "mongodb+srv://%s:%s@%s-%s/%s?retryWrites=true",
                    options()$mongodb$username,
                    options()$mongodb$password,
                    options()$mongodb$cluster,
                    options()$mongodb$host,
                    databaseName))
    
    # Insert the data into the mongo collection as a data.frame
    data <- as.data.frame(data)
    db$insert(data)
}
```

 
&nbsp;

3. Once you use the `saveData(data)` function to save some data, you can
load it right back up!

```{r}
loadData <- function() {
    # Connect to the database
    db <- mongo(collection = collectionName,
                url = sprintf(
                    "mongodb+srv://%s:%s@%s/%s",
                    options()$mongodb$username,
                    options()$mongodb$password,
                    options()$mongodb$host,
                    databaseName))
    
    # Read all the entries
    data_output <- db$find()
    data_output
}
```
$md$),
  ('post'::public.entry_kind, 'phd-first-semester', 'PhD Semester in Brief: Fall 2020', 'What was my first PhD semester like?', '2020-12-22', null, false, $md$Writing goals:
* One 7.50 paper sets
* One 7.89 paper set
* One concept from each of the 3 parts of genetics
* Three concepts from 7.51
$md$),
  ('news'::public.entry_kind, 'news-2024-08-30', '', '', '2024-08-30', null, true, $md$A paper with my Polygence mentee Kevin Yang, on predicting smoking status from RNA sequencing data, is published in the [Journal of Emerging Investigators](https://doi.org/10.59720/23-099).$md$),
  ('news'::public.entry_kind, 'news-2022-05-07', '', '', '2022-05-07', null, true, $md$Our paper on ubiquitous mRNA decay fragments in *E. coli* is published in [Nucleic Acids Research](https://doi.org/10.1093/nar/gkac295).$md$),
  ('news'::public.entry_kind, 'news-2021-05-17', '', '', '2021-05-17', null, true, $md$I joined the [Gene-Wei Li lab](http://gwli.scripts.mit.edu/group/).$md$),
  ('news'::public.entry_kind, 'news-2021-05-06', '', '', '2021-05-06', null, true, $md$I finished my research rotations in [Gene-Wei Li lab](http://gwli.scripts.mit.edu/group/), [Burge lab](https://www.genes.mit.edu/), and [Laub lab](https://www.laublab.mit.edu/).$md$),
  ('news'::public.entry_kind, 'news-2020-10-08', '', '', '2020-10-08', null, true, $md$My first primary-author paper is published [here in Scientific Reports](https://www.nature.com/articles/s41598-020-73987-0).$md$),
  ('news'::public.entry_kind, 'news-2020-09-01', '', '', '2020-09-01', null, true, $md$My first PhD semester at MIT!$md$),
  ('news'::public.entry_kind, 'news-2019-06-01', '', '', '2019-06-01', null, true, $md$I gave a talk at the 2019 International *C. elegans* meeting. [More information](https://julianstanley.github.io/IWM_2019/).$md$);
