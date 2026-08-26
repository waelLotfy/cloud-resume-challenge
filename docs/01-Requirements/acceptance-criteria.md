# Acceptance Criteria

**FR4**: Resume deployed as S3 static website
✓ Visiting the S3 website endpoint URL returns the resume HTML with 200 status

**FR5**: HTTPS enabled
✓ Visiting the site over http:// redirects to https://
✓ Browser shows valid padlock/certificate

**FR10**: Visitor counter displays count
✓ Counter shows a number on page load
✓ Refreshing the page increments the number by 1

**NFR2**: Free tier cost
✓ AWS Cost Explorer shows $0 or near-$0 charges after 1 week of testing
