import SummaryTable from '@/components/pages/explorationTables/summaryTable';
import { createPage } from '@/global/utils/pages';

const SummaryPage = createPage({
	getInitialProps: async ({ query, egoJwt }) => {
		return { query, egoJwt };
	},
	isPublic: true,
})(() => {
	return <SummaryTable />;
});

export default SummaryPage;
