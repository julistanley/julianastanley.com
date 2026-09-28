-- =============================================================================
-- 0003: fixes from the post-build review (run once, after 0001 and 0002).
--
-- 1. is_admin() now compares emails case-insensitively on both sides, and
--    app_admins rejects mixed-case rows, so adding an editor with a
--    capitalized email can never silently fail RLS checks.
-- 2. Slugs that collide with the site's real directories are rejected in the
--    database itself (the editor also refuses them).
-- 3. Content fixes: dead links found by a link check (the julianstanley ->
--    julistanley GitHub rename broke *.github.io URLs; Pam Silver's lab moved
--    to silverlabhms.org; sensoroverlord.org and cygnaltx.com are offline;
--    the Twitter account no longer exists) and two service items from the CV
--    (Biochemistry Club, Peer Health Exchange) that were missing from the
--    teaching page.
-- =============================================================================

create or replace function public.is_admin()
returns boolean language sql stable security definer set search_path = public as $$
  select exists (
    select 1 from public.app_admins
    where lower(email) = lower(coalesce(auth.jwt() ->> 'email', ''))
  );
$$;

alter table public.app_admins
  add constraint app_admins_email_lowercase check (email = lower(email));

alter table public.entries
  add constraint entries_slug_not_reserved check (
    slug not in ('admin', 'assets', 'css', 'js', 'snapshots', 'scripts',
                 'supabase', 'redirect-site', 'index.html')
  );

-- ---------- Content fixes (each write is also recorded in entry_history) ----

update public.entries set body = $md$<img class="portrait" src="/assets/img/prof_pic.jpg" alt="Juliana Stanley">

julianst[at]mit[dot]edu · [eight-five-eight]837-0221 · Boston, MA

**Brief CV**

- 2020–present: PhD Student (Department of Biology), Massachusetts Institute of Technology.
  - [Gene-Wei Li lab](http://gwli.scripts.mit.edu/group/). Currently characterizing mechanisms of leaderless mRNA translation in bacteria.
- 2018–2020: MS Bioinformatics, Northeastern University.
  - Research with [Pam Silver's lab](https://www.silverlabhms.org/) in the Department of Systems Biology at Harvard Medical School.
- 2015–2019: BS Biology, Northeastern University.
  - 2015–2019: Thesis with [Javier Apfeld's lab](https://apfeldlab.mystrikingly.com/).
  - 2017–2018: Research Assistant at Cygnal Therapeutics.

[Full CV (PDF)](/assets/files/CV.pdf)

My research interests are still developing. Generally, I'm interested in building models for how microorganisms adapt to different environments.

I think that research should be entirely reproducible. So, I am trying to hold myself accountable by having detailed methods for every paper that I write. Additionally, I also try to have a GitHub repository for each project for additional resources and source code.

If you would like to reach me, feel free to just shoot an email. Alternatively, you can just text me at the number listed above--don't be shy!

[email](mailto:%6A%75%6C%69%61%6E%73%74@%6D%69%74.%65%64%75) · [ORCID](https://orcid.org/0000-0002-9193-3791) · [Google Scholar](https://scholar.google.com/citations?user=N0D7hFYAAAAJ) · [GitHub](https://github.com/julistanley) · [LinkedIn](https://www.linkedin.com/in/julianstanley)
$md$ where slug = 'about';

update public.entries set body = $md$See [Google Scholar](https://scholar.google.com/citations?user=N0D7hFYAAAAJ) for a full list of publications. Google doesn't always index things correctly, so my [ORCID](https://orcid.org/0000-0002-9193-3791) can be more reliable.

I previously published under the name Julian A. Stanley; my ORCID lists all published aliases.

#### 2024

- Yang, K. & **Stanley, J.** Predicting smoking status based on RNA sequencing data. Journal of Emerging Investigators 7 (2024). [Open Access](https://doi.org/10.59720/23-099). A teaching-related publication with my Polygence mentee, Kevin Yang.

#### 2022

- Herzel, L., **Stanley, J. A.**, Yao, C.-C. & Li, G.-W. Ubiquitous mRNA decay fragments in *E. coli* redefine the functional transcriptome. Nucleic Acids Research 50, 5029–5046 (2022). [Open Access](https://doi.org/10.1093/nar/gkac295)

#### 2020

- **Stanley, J. A.**, Johnsen, S. B. & Apfeld, J. The SensorOverlord predicts the accuracy of measurements with ratiometric biosensors. Sci Rep 10, 16843 (2020). [Open Access](https://www.nature.com/articles/s41598-020-73987-0) \| [Supplement](https://uploads.strikinglycdn.com/files/99afd93f-4c35-47a5-8b31-520f483eb08a/Stanley2020supplement.pdf) \| [Code](https://github.com/apfeldlab/sensoroverlord) \| [Website](https://apfeldlab.github.io/SensorOverlord/)

- Schiffer, J. A. et al. Caenorhabditis elegans processes sensory information to choose between freeloading and self-defense strategies. eLife 9, e56186 (2020). [Open Access](https://elifesciences.org/articles/56186)

- Chang, R. L., **Stanley, J. A.** et al. Protein structure, amino acid composition and sequence determine proteome vulnerability to oxidation‐induced damage. EMBO J 39, (2020). [Open Access](https://www.embopress.org/doi/full/10.15252/embj.2020104523) \| [Code](https://github.com/julistanley/ProteinFeatures) \| [Extra Documentation](https://julistanley.github.io/ProteinFeatures/docs/public/intro_public.html)

#### 2019

- de la Parra, J., **Stanley, J.**, Foster, S., Webb, C. & Lykourinou, V. Crafting A More Environmentally Benign Extraction and Analysis of Pharmaceutical Precursors from a Medicinal Plant: A Student-Led Innovation. chemRxiv (2019). [Open Access](https://doi.org/10.26434/chemrxiv.7791716.v1)

#### Patents

From my time at Cygnal Therapeutics (Kahvejian et al.):

- Methods and Compositions for Treating Inflammatory or Autoimmune Diseases or Conditions Using Serotonin Receptor Activators. [US11208475B1](https://patents.google.com/patent/US11208475B1) (2021).
- Methods and Compositions for Treating Inflammatory or Autoimmune Diseases or Conditions Using GRM8 Activators. [US11059886B1](https://patents.google.com/patent/US11059886B1) (2021).
- Methods and Compositions for Treating Cancer Using Serotonin Receptor Inhibitors. [US11034751B1](https://patents.google.com/patent/US11034751B1) (2021).
- Methods for Treating Cancer Using GRM8 Inhibitors. [US10683352B1](https://patents.google.com/patent/US10683352B1) (2020).
$md$ where slug = 'publications';

update public.entries set body = $md$## Spring 2024

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
- **Northeastern University Biochemistry Club** (2016–2019) — wrote organization grants, including applying for and implementing two years of the Northeast-regional undergraduate conference of the American Society for Biochemistry and Molecular Biology.
- **Peer Health Exchange** (2015–2017) — taught weekly, 30–45-minute classes about physical and emotional health to high school students in Boston-area public schools.
$md$ where slug = 'teaching';

update public.entries set body = $md$I gave a talk at the 2019 International *C. elegans* meeting. [More information](https://julistanley.github.io/IWM_2019/).$md$ where slug = 'news-2019-06-01';
